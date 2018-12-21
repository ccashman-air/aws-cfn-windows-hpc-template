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
# This PowerShell script confgures the network adapter for a member of a compute cluster
#
# It must be called with the domain DNS name, and with the name of the network adapter
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$InterfaceNewName
)

Import-Module ServerManager

Write-Host "Firewall deactivation"
Set-NetFirewallProfile -All -Enabled False

Write-Host "Renaming network card"
$adapterName = (Get-NetAdapter | Select-Object -ExpandProperty Name -First 1)
Rename-NetAdapter -Name $adapterName -NewName $InterfaceNewName

Write-Host "Reading adapter configuration"
$private    = (Get-NetIPAddress -InterfaceAlias $InterfaceNewName -AddressFamily IPv4)
$privateIp  = $private.IPAddress
$privatePl  = $private.PrefixLength
$privateGw  = (Get-NetIPConfiguration -InterfaceAlias $InterfaceNewName).IPv4DefaultGateway.NextHop

Write-Host "Deactivating IPv6"
Disable-NetAdapterBinding  -InterfaceAlias $InterfaceNewName -ComponentID ms_tcpip6 -Confirm:$false

Write-Host "Using Static IP"
#Remove-NetIPAddress -InterfaceAlias $InterfaceNewName -IPAddress $privateIp -Confirm:$false
#New-NetIPAddress    -InterfaceAlias $InterfaceNewName -IPAddress $privateIp -PrefixLength $privatePl -DefaultGateway $privateGw -Confirm:$false