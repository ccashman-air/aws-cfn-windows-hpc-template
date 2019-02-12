# AWS CloudFormation Windows HPC Template
#
# Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

#
# This script publishes the local AWS CloudFormation templates to an Amazon S3 bucket
#

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateNotNullOrEmpty()]
    [string]$Bucket,

    [Parameter(Mandatory=$false)]
    [string]$Prefix="",

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$Profile
)

$ErrorActionPreference = "Stop"

if (Test-Path -Path env:\AWSCLI_PROFILE) {
    $Profile = (Get-Item -Path env:\AWSCLI_PROFILE).Value
}
elseif (-not $PSBoundParameters.ContainsKey("Profile")) {
    throw "Profile name not specified."
}

if ($Prefix -eq $null)
{
    $Prefix = ""
}
else
{
    $Prefix = $Prefix.Trim("/")
}

if ($Prefix -eq "")
{
    $FilesPrefix=""
    $Destination="${Bucket}"
    $HttpDestination="https://${Bucket}.s3.amazonaws.com"
}
else
{
    $FilesPrefix="${Prefix}/"
    $Destination="${Bucket}/${Prefix}"
    $HttpDestination="https://${Bucket}.s3.amazonaws.com/${Prefix}"
}

Write-Host "#####"
Write-Host "Publishing files to 's3://${DESTINATION}'"

Write-Host ""
Write-Host "Publishing AWS Lambda function sources"

Get-ChildItem "lambda" -Filter *.js | ForEach-Object {
    $FullName = $_.FullName
    $BaseName = $_.BaseName
    $TmpName  = "${FullName}.zip"
  
    $_ | Compress-Archive -DestinationPath "${FullName}.zip" -Force | Out-Null
    & aws s3 cp $tmpName "s3://${Destination}/lambda/${BaseName}.zip" --profile $Profile
    Remove-Item $TmpName
}

Write-Host ""
Write-Host "Publishing PowerShell Scripts"
Get-ChildItem "cfn-init" -Filter *.ps1 | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name

    aws s3 cp $FullName "s3://${Destination}/cfn-init/${FileName}" --profile $Profile
}

Write-Host ""
Write-Host "Publishing Configuration Files (CONF)"
Get-ChildItem "cfn-init" -Filter *.conf | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name

    & aws s3 cp $FullName "s3://${Destination}/cfn-init/${FileName}" --profile $Profile
}

Write-Host ""
Write-Host "Publishing Configuration Files (JSON)"
Get-ChildItem "cfn-init" -Filter *.json | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name

    & aws s3 cp $FullName "s3://${Destination}/cfn-init/${FileName}" --profile $Profile
}

Write-Host ""
Write-Host "Publishing AWS CloudFormation templates"
Get-ChildItem    -Filter *.json | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name
    $TmpName = "${FullName}.tmp"

    Get-Content $FullName | `
        ForEach-Object { $_.Replace("<SUBSTACKSOURCE>", "${HttpDestination}/").Replace("<BUCKETNAME>", $Bucket).Replace("<PREFIX>", $FilesPrefix).Replace("<DESTINATION>", $Destination) } | `
        Set-Content $TmpName

    & aws s3 cp $TmpName "s3://${Destination}/${FileName}" --profile $Profile
    Remove-Item $TmpName
}

Write-Host ""
Write-Host "Publishing AWS CloudFormation sub stacks"
Get-ChildItem    -Filter cfn/*.json | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name
    $TmpName = "${FullName}.tmp"

    Get-Content $FullName | `
        ForEach-Object { $_.Replace("<SUBSTACKSOURCE>", "${HttpDestination}/").Replace("<BUCKETNAME>", $Bucket).Replace("<PREFIX>", $FilesPrefix).Replace("<DESTINATION>", $Destination) } | `
        Set-Content $TmpName

    & aws s3 cp $TmpName "s3://${Destination}/cfn/${FileName}" --profile $Profile
    Remove-Item $TmpName
}

Write-Host ""
Write-Host "Publishing SSL and CA certificates"

Get-ChildItem "cfn-init" -Filter *.pfx | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name
    & aws s3 cp $FullName "s3://${Destination}/cfn-init/${FileName}" --profile $Profile
}

Get-ChildItem "cfn-init" -Filter *.cer | ForEach-Object {
    $FullName = $_.FullName
    $FileName = $_.Name
    & aws s3 cp $FullName "s3://${Destination}/cfn-init/${FileName}" --profile $Profile
}

Write-Host ""
Write-Host "Start the cluster by using the '${HttpDestination}/0-all.json' AWS CloudFormation Stack"