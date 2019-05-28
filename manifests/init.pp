# Manage the installation of Red Hat Developer Toolset
class scldevtoolset(
  Array[Integer] $versions = [$scldevtoolset::params::latest_version]
) inherits scldevtoolset::params {

  $package_versions = $versions.map |$x| { "devtoolset-${x}" }

  case $facts['os']['name'] {
    'CentOS': {
      package { $scldevtoolset::params::package_name:
        ensure => present,
        before => $package_versions.map |$x| { Package[$x] },
      }
    }
    default: {
      # Empty.
    }
  }

  $package_versions.map |$x| { package { $x: ensure => present } }

}