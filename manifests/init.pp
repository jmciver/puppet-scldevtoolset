# Manage the installation of Red Hat Developer Toolset
class scldevtoolset(
  Array[Integer] $versions = [$scldevtoolset::params::max_version]
) inherits scldevtoolset::params {

  $packages_to_install = $versions.map |$x| { "devtoolset-${x}" }
  $packages_to_remove = range(
    $scldevtoolset::params::min_version,
    $scldevtoolset::params::max_version)
    .filter |$x| { ! ($x in $versions) }
    .map |$x| { "devtoolset-${x}" }

  case $facts['os']['name'] {
    'CentOS': {
      package { $scldevtoolset::params::package_name:
        ensure => present,
        before => concat($packages_to_install, $packages_to_remove)
          .map |$x| { Package[$x] },
      }
    }
    default: {
      # Empty.
    }
  }

  $packages_to_install.map |$x| { package { $x: ensure => present } }
  $packages_to_remove.map |$x| { package { $x: ensure => absent } }

}