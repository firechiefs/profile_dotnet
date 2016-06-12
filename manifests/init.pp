# PURPOSE:
# installs .Net 4.x
#
# HIERA EXAMPLE:
# profile::dotnet:
#  version: '4.5.2'
#  release: '379893'
#  repo_path: '/Install/packages/windows/net/'
#  installer: 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe'
#
# HIERA KEY/VALUES:
# version = .NET version of installer
# release = registry "release" value for .NET installer
# repo_path = path to installer on repository server
# installer = executable for .NET installer
#
# module dependencies
# puppet module install puppet-download_file
# puppet module install puppetlabs-reboot


class profile_dotnet {
  # HIERA LOOKUP:
  # --> PUPPET CODE VARIABLES
  # URL of repository server
  $repo_url            = hiera('global::repo_url')
  # directory where installer will be staged
  $temp_directory      = hiera("global::temp_directory.${::osfamily}")
  # hash containing .NET details
  $dotnet              = hiera_hash('profile::dotnet')

  # HIERA LOOKUP VALIDATION:
  validate_string($repo_url)
  validate_string($temp_directory)
  validate_hash($dotnet)

  # PUPPET CODE:
  $rel = 0 + $::dotnet4_release # convert to integer
  # check if local version matches hiera lookup
  if( $rel < $dotnet[release] ) {
    # stage .NET4 installer if local version does not match heira lookup
    download_file { $dotnet[version]:
      url                   =>
        "${repo_url}${dotnet[repo_path]}${dotnet[installer]}",
      destination_directory => $temp_directory,
    } -> # exec requires download_file
    # install .NET that was just staged
    exec { $dotnet[version]:
      command => "${temp_directory}\\${dotnet[installer]} /q /norestart",
      returns => [0, 3010] # 3010 = ERROR_SUCCESS_REBOOT_REQUIRED
    } ~> # reboot and log message only if exec resource executed
    reboot { $dotnet[version]:
      message => "Rebooting after .NET ${dotnet[version]} install",
      apply   => finished, # reboot only after puppet run finishes
    }
  }

  # VALIDATION CODE:
  # --> MODIFY VARIABLES BELOW:
  $profile_name    = 'profile_dotnet'           # set to profile name
  $validation_data = $dotnet # set to data you'd like to validate

  # Puppet custom define type
  # documented in: site/validation_script/manifests/init.pp
  # DO NOT MODIFY BELOW !!!
  validation_script { $profile_name:
    profile_name    => $profile_name,
    validation_data => $validation_data,
  }

}
