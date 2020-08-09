# @summary Manage the installation of Red Hat Developer Toolset
#
# @param array Developer Toolset versions to install
#
# @param scl_package_name Software Collections package name
#
# @param use_modules if set to true installs associated environment
#   module for each Developer Tools set version specified
#
# @param install_environment_modules install the environment-modules
#  system package

class scldevtoolset(
  Array[Integer] $versions,
  String $scl_package_name,
  Boolean $use_modules = false,
  Boolean $install_environment_modules = false,
) {

  $packages_to_install = $versions.map |$x| { "devtoolset-${x}" }

  case $facts['os']['name'] {
    'CentOS': {
      package { $scl_package_name:
        ensure => present,
        before => $packages_to_install.map |$x| { Package[$x] },
      }
    }
    default: {
      # Empty.
    }
  }

  $packages_to_install.map |$x| { package { $x: ensure => present } }

  if $use_modules {
    class { 'scldevtoolset::install_module_files':
      versions                    => $versions,
      install_environment_modules => $install_environment_modules,
    }
  }

}
