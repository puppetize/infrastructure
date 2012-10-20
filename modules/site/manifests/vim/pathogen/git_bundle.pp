# Clone a Git repository as a system-wide Vim bundle.
#
# == Parameters
#
# - *name*: name of the Vim bundle
# - *source*: Git repository URI or a hash of *name* => *source* pairs where
#   the clone URI is looked up via the *name* parameter.
define site::vim::pathogen::git_bundle($source)
{
  include site::git
  include site::vim::pathogen

  if is_hash($source) {
    if is_string($source[$name]) {
      $clone_uri = $source[$name]
    } else {
      fail("source[$name] must be a string")
    }
  } elsif is_string($source) {
    $clone_uri = $source
  } else {
    fail("'source' parameter must be a string or a hash")
  }

  $destination = "${site::vim::pathogen::bundle_dir}/${name}"

  exec { "${module_name}/git-clone/${name}":
    command   => "${site::git::executable} clone '${clone_uri}' '${destination}'",
    creates   => "${destination}/.git",
    logoutput => on_failure,
    require   => Class['site::git']
  }
}
