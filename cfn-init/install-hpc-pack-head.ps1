# 
# AWS CloudFormation Windows HPC Template
# 
# Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
#  http://aws.amazon.com/apache2.0
# 
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
# 

# 
# This PowerShell script installs Microsoft HPC Pack on a Head Node 
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$UserFile
)

if (-not (Test-Path $UserFile))
{
    Throw "File '$UserFile' does not exist, exiting script"
}

$content = Get-Content $UserFile
$sslPS = $content[5]

Import-Module ServerManager

Install-WindowsFeature DHCP, FS-Resource-Manager, DirectAccess-VPN, Routing, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Static-Content, Web-Http-Logging, Web-Stat-Compression, Web-Filtering, Web-IP-Security, Web-Scripting-Tools, WDS-Transport, MSMQ-Server, Windows-Internal-Database

Write-Host "Starting Installation"
Write-Host ""
Write-Host "- Install SQL"

D:\SQLInstall\setup.exe /CONFIGURATIONFILE=C:\cfn\install\sql-config.conf

Write-Host ""
Write-Host "- Install HPC Pack"

# Removed -RuntimeShare:"D:\HPCRuntimeDirectory"
#
D:\HPCPack2016Update2-Full\Setup.exe -Unattend -HeadNode -InstallDir:"D:\HPCPack2016" -DataDir:"D:\HPCPack2016\Data" -MgmtDbDir:"D:\HPCPack2016\Database\Data\ManagementDB" -MgmtDbLogDir:"D:\HPCPack2016\Database\Log\ManagementDB" -SchdDbDir:"D:\HPCPack2016\Database\Data\SchedulerDB" -SchdDbLogDir:"D:\HPCPack2016\Database\Log\SchedulerDB" -ReportingDbDir:"D:\HPCPack2016\Database\Data\ReportingDB" -ReportingDbLogDir:"D:\HPCPack2016\Database\Log\ReportingDB" -DiagDbDir:"D:\HPCPack2016\Database\Data\DiagnosticsDB" -DiagDbLogDir:"D:\HPCPack2016\Database\Log\DiagnosticsDB" -MonDbDir:"D:\HPCPack2016\Database\Data\MonitoringDB" -MonDbLogDir:"D:\HPCPack2016\Database\Log\MonitoringDB" -SSLPfxFilePath:"C:\cfn\install\ssl-cert.pfx" -SSLPfxFilePassword:"$sslPS" -CACertificate:"C:\cfn\install\ca-cert.cer"
