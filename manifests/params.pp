# Parameters used to manage the installation of the Red Hat Developer
# Toolset
class scldevtoolset::params {

  $min_version = 3
  $max_version = 8

  case $facts['os']['name'] {
    'CentOS': {
      $package_name = 'centos-release-scl'
      $init_resource = Package[$package_name]
    }
    default: {
      fail("the scldevtoolset module does not currently support OS: \"${facts['os']['name']}\"")
    }
  }

}