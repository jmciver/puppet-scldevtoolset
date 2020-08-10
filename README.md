# Software Collections Developer Toolset

[![Build Status](https://travis-ci.com/jmciver/puppet-scldevtoolset.svg?branch=master)](https://travis-ci.com/jmciver/puppet-scldevtoolset)

Install [Software Collections](https://www.softwarecollections.org/en/) Developer Toolset packages.

#### Table of Contents

1. [Description](#description)
    * [Supported Operating Systems](#supported-operating-systems)
2. [Setup - the basics of getting started with scldevtoolset](#setup)
    * [Beginning with scldevtoolset](#beginning-with-scldevtoolset)
3. [Usage - Configuration options](#usage)
    * [YAML](#yaml)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [License - Where and how this module can be used](#license)

## Description

This module will enable the Software Collections repository and
install the specified version or versions of the Development Tools
package. Versions of the Developer Tools that are not specified are
removed. YAML configuration is supported.

### Supported Operating Systems

Currently only CentOS 6 and 7 platforms are supported. RedHat
Workstation support is currently under development.

|            | **6**  | **7**  | **8**  |
|:---        | :----: | :----: | :----: |
| **CentOS** | Yes    | Yes    | NA     |
| **RHEL**   | No     | No     | NA     |

## Setup

### Beginning with scldevtoolset

The default configuration installs version 9 of the Developer Tools:
```
include scldevtoolset
```

## Usage

Install version 8 of the [Developer Tools](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-8):
```
class { 'scldevtoolset':
  versions => [8]
}
```

Install versions 7, 8, and 9 of the Developer Tools:
```
class { 'scldevtoolset':
  versions => [7, 8, 9]
}
```

Install version 9 of and supporting environment module:
```
class { 'scldevtoolset':
  versions    => [9],
  use_modules => true,
}
```

The environment-module system package can installed by setting the
`install_modules_package` parameter to true.

### YAML

Install version 8 of the Developer Tools:
```
scldevtoolset::versions:
  - 8
```

Install versions 7, 8, and 9 of the Developer Tools:
```
scldevtoolset::versions:
  - 7
  - 8
  - 9
```

Install version 9 of and supporting environment module:
```
scldevtoolset::versions:
  - 9
scldevtoolset::use_modules: true
```

## Limitations

Currently this module only supports CentOS version 6 and 7.

## Development

Will add to this later.

## License

This module is released under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0.html).
