#!/usr/bin/env python3

import os
import pathlib
import hashlib
import datetime
import requests
import ruamel.yaml
import shutil
from urllib.parse import urlparse

# Define constants
YAML_FILE = "stone.yaml"
CACHE_DIR = "/var/lib/solbuild/sources"
DOWNLOAD_DIR = "/tmp"


def calculate_sha256(filepath):
    """Calculates the SHA256 hash of a file."""
    sha256_hash = hashlib.sha256()
    try:
        with open(filepath, "rb") as f:
            # Read and update hash string in chunks
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    except FileNotFoundError:
        print(f"Error: File not found for hashing: {filepath}")
        return None
    except Exception as e:
        print(f"Error calculating hash for {filepath}: {e}")
        return None


def get_file_modification_time(filepath):
    """Gets the modification time of a file in the required format for If-Modified-Since."""
    try:
        mtime = os.path.getmtime(filepath)
        return datetime.datetime.utcfromtimestamp(mtime).strftime('%a, %d %b %Y %H:%M:%S GMT')
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"Error getting modification time for {filepath}: {e}")
        return None


def main():
    yaml = ruamel.yaml.YAML()
    yaml.preserve_quotes = True
    yaml.indent(mapping=4, sequence=4, offset=4)
    yaml.top_level_colon_align = True

    yaml_data = None
    try:
        with open(YAML_FILE, 'r') as f:
            yaml_data = yaml.load(f)
    except FileNotFoundError:
        print(f"Error: {YAML_FILE} not found.")
        return
    except Exception as e:
        print(f"Error reading {YAML_FILE}: {e}")
        return

    # Validate data
    if not yaml_data or 'upstreams' not in yaml_data or not isinstance(yaml_data.get('upstreams'), list):
        print(f"Error: Invalid or missing 'upstreams' section in {YAML_FILE}. Expected a list under 'upstreams'.")
        return

    updated_sources_list = []
    hashes_changed = False

    for entry in yaml_data['upstreams']:
        if not isinstance(entry, dict) or len(entry) != 1:
            print(f"Warning: Skipping unexpected entry format: {entry}")
            continue

        url = list(entry.keys())[0]
        props = entry[url]  # Now a dict like {'hash': '...', 'unpack': False}
        expected_hash = props.get('hash')
        unpack = props.get('unpack', False)

        filename = pathlib.Path(urlparse(url).path).name
        hash_based_subdir = expected_hash

        old_path = pathlib.Path(CACHE_DIR) / hash_based_subdir / filename
        new_dir = pathlib.Path(DOWNLOAD_DIR) / hash_based_subdir
        new_path = new_dir / filename

        print(f"==> Processing {filename}")

        download_successful = False
        downloaded_file_path = None

        try:
            new_dir.mkdir(parents=True, exist_ok=True)

            # Conditional download using If-Modified-Since
            headers = {}
            if old_path.exists():
                mod_time = get_file_modification_time(old_path)
                if mod_time:
                    headers['If-Modified-Since'] = mod_time

            response = requests.get(url, headers=headers, stream=True, timeout=30)

            if response.status_code == 304:
                print("File not modified, using cached version.")
                download_successful = True
                downloaded_file_path = old_path
            elif response.status_code == 200:
                print("Downloading fresh file...")
                with open(new_path, 'wb') as f:
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)
                download_successful = True
                downloaded_file_path = new_path
            else:
                print(f"Warning: download failed with status {response.status_code}")
                if old_path.exists():
                    downloaded_file_path = old_path
                    download_successful = True

        except Exception as e:
            print(f"Error downloading {url}: {e}")
            if old_path.exists():
                downloaded_file_path = old_path
                download_successful = True

        calculated_hash = calculate_sha256(downloaded_file_path) if download_successful else None
        final_hash = calculated_hash if calculated_hash else expected_hash
        if calculated_hash and calculated_hash != expected_hash:
            print(f"Hash mismatch for {filename}, updating hash.")
            hashes_changed = True

        # Append updated entry preserving 'unpack'
        updated_sources_list.append({url: {'hash': final_hash, 'unpack': unpack}})

        # Cleanup
        if new_dir.exists():
            try:
                shutil.rmtree(new_dir)
            except Exception as e:
                print(f"Error cleaning up {new_dir}: {e}")

    print("\n" + "="*20)
    if not hashes_changed:
        print("No changed hashes for sources found")
    else:
        print(f"Attempting to update {YAML_FILE}...")

        # --- In-place update of the YAML file ---
        try:
            # Check if any hashes were changed before updating version and release
            if hashes_changed:
                print("Hashes have changed. Updating version and incrementing release.")
                # Update the 'version' key with the current date
                yaml_data['version'] = datetime.datetime.now().strftime("%Y%m%d")

                # Increment the 'release' key if it exists and is an integer
                if 'release' in yaml_data and isinstance(yaml_data['release'], int):
                    yaml_data['release'] += 1
                else:
                    print(f"Warning: Cannot increment 'release' key. It is missing or not an integer.")

            with open(YAML_FILE, 'w') as f:
                # Update the 'source' section in the loaded data structure
                if 'upstreams' in yaml_data and isinstance(yaml_data['upstreams'], list):
                    yaml_data['upstreams'] = updated_sources_list
                else:
                    print(f"Error: 'upstreams' section not found or not a list in {YAML_FILE} during update phase.")
                    return

                # Dump the modified data structure back into the YAML file
                yaml.dump(yaml_data, f)

            print(f"{YAML_FILE} updated successfully.")

        except FileNotFoundError:
            print(f"Error: {YAML_FILE} not found during the update attempt.")
        except Exception as e:
            print(f"Error writing updated data to {YAML_FILE}: {e}")

        # --- End of In-place update ---

    print("\n" + "="*20)

    print("✅ Finished")


if __name__ == "__main__":
    main()
