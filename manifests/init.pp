# Manage the installation of Red Hat Developer Toolset
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
