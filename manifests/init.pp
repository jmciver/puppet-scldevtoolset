# Manage the installation of Red Hat Developer Toolset
class scldevtoolset(
  Array[Integer] $versions,
  String $scl_package_name,
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

}
