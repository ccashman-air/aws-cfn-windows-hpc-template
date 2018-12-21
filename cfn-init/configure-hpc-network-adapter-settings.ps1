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

Write-Host "Activating Jumbo Frames and deactivating Interrupt Moderation"
netsh int ip set subinterface "$InterfaceNewName" mtu=9001 store=persistent
#Set-NetAdapterAdvancedProperty -Name $InterfaceNewName -RegistryKeyword "*JumboPacket" -RegistryValue 9014
#Set-NetAdapterAdvancedProperty -Name $InterfaceNewName -RegistryKeyword "*InterruptModeration" -RegistryValue 0
