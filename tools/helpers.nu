const RELEASE_MONITORING_URL = "https://release-monitoring.org/api/v2/versions/"
const CPE_SEARCH_URL = "https://cpe-guesser.cve-search.org/search"
const CPE_COMMON_PREFIX = "cpe:2.3:a:"
export const AOS_REPO_PATH = path self | path dirname | path dirname
const YAML_REQUIREMENTS = [ monitoring.yaml stone.yaml ]

use std/dirs

# Check AerynOS package is latest in recipes repo.
export def checkupdate [
  package?: string@package_list
]: nothing -> table {
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

  open stone.yaml
  | select name version
  | str trim -c "'" | str trim -c '"'
  | rename -c {version: current_version}
  | update current_version {into string}
  | insert available_version (
    http get (
      $RELEASE_MONITORING_URL
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
  | insert status {
    |row| if ($row.current_version == $row.available_version) {
      $"(ansi green)Already using the latest version(ansi reset)"
    } else {
      $"(ansi red_bold)Update available(ansi reset)"
    }
  }
}

# Primitive CPE search tool
export def cpesearch [
  package?: string@package_list # Package name
]: nothing -> table {
  mut target = $package
  if ($package | is-empty ) {
    print "Warning: No paramaters passed, using current directory name. Pass --help to see usage"
    $target = pwd | path basename
  }

  http post --content-type application/json $CPE_SEARCH_URL ({query: [$target]})
  | each {|cpe_result|
    { cpe_id: $cpe_result.0 trash: (
        $cpe_result.1
        | str replace $CPE_COMMON_PREFIX ''
        | split column : -n 2
        | rename vendor product
      )
    }
  } | flatten | flatten
  | insert cve_link {|row|
    $"https://cve.circl.lu/search?vendor=($row.vendor)&product=($row.product)"
    | ansi link
  }
}

# Go to the root directory of the AerynOS recipes
export def --env gotoaosrepo []: nothing -> nothing {cd $AOS_REPO_PATH}

# Deprecated! Use `gotoaosrepo`
export alias gotoserpentrepo = gotoaosrepo

# Go to the root of current git repository
export def --env goroot []: nothing -> nothing {
  try {
    cd (git rev-parse --show-toplevel)
  } catch {
    error make -u {msg: $"Seems like you are not in a git repository"}
  }
}

# Push into a package directory
export def --env chpkg [
  package: string@package_list # Package name
]: nothing -> nothing {
  try {
    cd ($AOS_REPO_PATH | path join ($package | split chars | first) $package)
  } catch {
    error make -u {msg: $"Couldn't find recipe for package ($package)" help: "There is autocomplete for existing packages you know..."}
  }
}

def package_list [
]: nothing -> table {
  ls ($"($AOS_REPO_PATH)/?/*" | into glob)
  | where type == dir
  | select name
  | upsert description {|row| open ($row.name | path join stone.yaml) | get summary}
  | update name {path basename}
  | rename -c {name: value}
}
