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
# This PowerShell script installs Microsoft HPC Pack on a Compute Node 
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

D:\HPCPack2016Update2-Full\Setup.exe -Unattend -ComputeNode:"HEAD-NODE" -SSLPfxFilePath:"C:\cfn\install\AIR-Win2012HPC2016.pfx" -SSLPfxFilePath:"C:\cfn\install\ssl-cert.pfx" -SSLPfxFilePassword:"$sslPS" -CACertificate:"C:\cfn\install\ca-cert.cer"
