# Software Collections Developer Toolset

[![Build Status](https://img.shields.io/travis/jmciver/puppet-scldevtoolset/master.svg)](https://travis-ci.com/jmciver/puppet-scldevtoolset)

Install [Software Collections](https://www.softwarecollections.org/en/) Developer Toolset packages.

#### Table of Contents

1. [Description](#description)
2. [Setup - the basics of getting started with scldevtoolset](#setup)
    * [Beginning with scldevtoolset](#beginning-with-scldevtoolset)
3. [Usage - Configuration options](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [License - Where and how this module can be used](#license)

## Description

This module will enable the Software Collections repository and
install the specified version or versions of the Development Tools
package. Versions of the Developer Tools that are not specified are
removed.

Currently only CentOS 6 and 7 platforms are under development. RedHat
Workstation support will follow.

## Setup

### Beginning with scldevtoolset

The default configuration installs version 8 of the Developer Tools:
```
include scldevtoolset
```

## Usage

Install version 7 of the [Developer Tools](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7):
```
class { 'scldevtoolset':
  versions => [7]
}
```

Install versions 6, 7, and 8 of the Developer Tools:
```
class { 'scldevtoolset':
  versions => [6, 7, 8]
}
```

## Limitations

Currently this module only supports CentOS version 6 and 7.

## Development

Will add to this later.

## License

This module is released under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0.html).
