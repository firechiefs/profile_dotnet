## PURPOSE:

Creates a custom fact on windows and Installs .Net 4.x

## HIERA DATA:
```
global::repo_url: <repository url>

global::temp_directory.${::osfamily}

profile::dotnet:
  version: <version of .net (string)>
  release: <release number (integer)>
  repo_path: <specific uri in your repo (string)>
  installer: <installation executable (string)>
```
## HIERA EXAMPLE:
```
global::repo_url: "http://server.foo.bar"

global::temp_directory:
  windows: 'C:\foo\temp'

profile::dotnet:
  version: '4.5.2'
  release: 379893
  repo_path: 'packages/windows/net/'
  installer: 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe'
```

## MODULE DEPENDENCIES:

puppet module install puppetlabs-reboot
puppet module install puppet-download_file

## USAGE:

#### Puppetfile:
```
mod "puppetlabs-reboot",     '1.2.1'
mod "puppet-download_file",  '1.2.1'

mod 'validation_script',
  :git => 'https://github.com/firechiefs/validation_script',
  :ref => '1.0.0'

mod 'profile_dotnet',
  :git => 'https://github.com/firechiefs/profile_dotnet',
  :ref => '1.0.3'
```
#### Manifests:
```
class role::*rolename* {
  include profile_dotnet
}
```
