# @summary Install system modules for Developer Toolset versions
#
# @param versions Developer Toolset version to generate environment
#   modules for
#
# @param environment_module_package name of environment modules
#   package
#
# @param install_environment_module if true install package defined by
#   environment_module_package
#
# @param base_module_path base modulefiles directory on system
#
# @param scl_devtoolset_module_dir directory under base_module_path
#    which will contain all Development Toolset version modules
#
# @param scl_devtoolset_base_dir default install location of the
#   Developer Toolset packages

class scldevtoolset::install_module_files (
  Array[Integer] $versions,
  String $environment_module_package,
  Boolean $install_environment_modules = false,
  String $base_module_path = '/etc/modulefiles',
  String $scl_devtoolset_module_dir = 'scl-devtools',
  String $scl_devtoolset_base_dir = '/opt/rh',
) {

  if $install_environment_modules {
    package { $environment_module_package:
      ensure => present,
    }
  }

  $full_scl_devtoolset_path = "${base_module_path}/${scl_devtoolset_module_dir}"

  file { $full_scl_devtoolset_path:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    purge   => true,
    require => Package[$environment_module_package],
  }

  $base_file = "${full_scl_devtoolset_path}/.base"

  file { $base_file:
    ensure  => file,
    content => epp('scldevtoolset/base-module'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => File[$full_scl_devtoolset_path],
  }

  $versions.map |$v| {
    file { "${full_scl_devtoolset_path}/${v}":
      ensure  => link,
      target  => $base_file,
      require => File[$base_file]
    }
  }

}
