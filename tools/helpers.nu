const release_monitoring_url = "https://release-monitoring.org/api/v2/versions/"
export const AOS_REPO_PATH = path self | path dirname | path dirname
const YAML_REQUIREMENTS = [ monitoring.yaml stone.yaml ]

use std/dirs

# Check AerynOS package is latest in recipes repo.
export def checkupdate [
  package?: string@package_list
] {
  try {
    dirs add (
      if ($package | is-not-empty) {
        $AOS_REPO_PATH
        | path join ($package | split chars | first) $package
      } else {
        pwd
      }
    )
  } catch {
    error make -u {msg: $"Couldn't find recipe for package ($package)" help: "There is autocomplete for existing packages you know..."}
  }
  
  $YAML_REQUIREMENTS | each {|yaml_req|
    if not ($yaml_req | path exists) {
      error make -u {msg: $"($yaml_req) file doesn't exist" help: "You must be either in a package recipe directory, or supply a package name"}
    }
  }

  let project_data = open stone.yaml
  | select name version
  | str trim -c "'" | str trim -c '"'
  | rename -c {version: current_version}
  | update current_version {into string}
  | merge {
    new_version: (
      http get (
        $release_monitoring_url
        | url parse
        | update params {
          project_id: (open monitoring.yaml | get releases.id)
        }
        | url join
      )
      | get stable_versions.0
      | str trim -c "'" | str trim -c '"' # Strip any quotes
      | str replace _ . # Replace any underscores with dots
    )
  }

  print $project_data

  if ($project_data.current_version == $project_data.new_version) {
    print "Already using the latest version"
  } else {
    print "Update available"
  }
}

# UNIMPLEMENTED1 PrimiTive CPE search tool
export def cpesearch [
  package?: string@package_list # Package name
] {
  mut target = $package
  if ($package | is-empty ) {
    print "Warning: No paramaters passed, using current directory name. Pass --help to see usage"
    $target = pwd | path basename
  }
  print $"($target)"
}

# Go to the root directory of the AerynOS recipes
export def --env gotoaosrepo [] {cd $AOS_REPO_PATH}
# Deprecated  use gotoausrepo
export alias gotoserpentrepo = gotoaosrepo

# Push into a package directory
export def --env chpkg [
  package: string@package_list # Package name
] {
  cd ($AOS_REPO_PATH | path join ($package | split chars | first) $package)
}

def package_list [
] {
  ls ($"($AOS_REPO_PATH)/?/*" | into glob)
  | where type == dir
  | select name
  | upsert description {|row| open ($row.name | path join stone.yaml) | get summary}
  | update name {path basename}
  | rename -c {name: value}
}
