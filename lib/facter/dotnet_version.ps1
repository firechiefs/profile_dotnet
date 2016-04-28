<#
.Synopsis

Returns the install .NET Framework versions as puppet facts

.Description

Thee script looks through the registry using the notes from the below
MSDN links to determine which versions of .NET are installed.

- https://msdn.microsoft.com/en-us/library/bb822049(v=vs.110).aspx
- https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx

.Notes
AUTHOR: David Mohundro
- https://gist.github.com/drmohundro/40244009b2f4f32b258b
Modified: Noe Gonzalez
#>

# returns
# dotnet2_version=2.0.50727.4927
# dotnet3_version=3.0.30729.4926
# dotnet35_version=3.5.30729.4926
# dotnet4_release=379893
# dotnet4_version=4.5.51650

# Registry path holding .NET version info
$ndpDirectory = 'hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\'

# check for .NET 2.x. If found, return version
if (Test-Path "$ndpDirectory\v2.0.50727") {
    $version = (Get-ItemProperty "$ndpDirectory\v2.0.50727").Version
    Write-Host "dotnet2_version=$version"
}

# check for .NET 3.x. If found, return version
if (Test-Path "$ndpDirectory\v3.0") {
    $version = (Get-ItemProperty "$ndpDirectory\v3.0").Version
    Write-Host "dotnet3_version=$version"
}

# check for .NET 3.5.x If found, return version
if (Test-Path "$ndpDirectory\v3.5") {
    $version = (Get-ItemProperty "$ndpDirectory\v3.5").Version
    Write-Host "dotnet35_version=$version"
}

# .NET 4.x version and release key do not match
# so let's create a dotnet4_version & dotnet4_release puppet fact
# https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx
$v4Directory = "$ndpDirectory\v4\Full"
if (Test-Path $v4Directory) {
    # determine .NET 4.x release value
    $release = (Get-ItemProperty $v4Directory).Release
    Write-Host "dotnet4_release=$release"

    # determine .NET 4.x version value
    $version = (Get-ItemProperty $v4Directory).Version
    Write-Host "dotnet4_version=$version"
}
