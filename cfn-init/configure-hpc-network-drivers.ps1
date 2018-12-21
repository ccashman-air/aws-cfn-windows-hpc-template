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
)

if (Test-Path "D:\PROWinx64\PROXGB\Winx64\NDIS64\vxn64x64.inf")
{
  Write-Host "Installing Intel Updated Network driver (SR-IOV)"
  #pnputil -i -a D:\PROWinx64\PROXGB\Winx64\NDIS64\vxn64x64.inf > "D:\PROWinx64\setup.log" 2>&1
}

if (Test-Path "D:\AWSPVDriverSetup\AWSPVDriverSetup.msi")
{
  Write-Host "Install AWS Updated Drivers"
  #& msiexec.exe /log "D:\AWSPVDriverSetup\install.log" /i "D:\AWSPVDriverSetup\AWSPVDriverSetup.msi" /quiet > "D:\AWSPVDriverSetup\setup.log" 2>&1
}