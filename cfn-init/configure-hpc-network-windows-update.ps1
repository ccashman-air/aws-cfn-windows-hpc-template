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

Write-Host "Deactivating Windows Update"
$AUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$AUSettings.NotificationLevel         = 1      # Disabled
$AUSettings.ScheduledInstallationDay  = 1      # Every Sunday
$AUSettings.ScheduledInstallationTime = 3      # 3AM
$AUSettings.IncludeRecommendedUpdates = $false # Disabled
$AUSettings.FeaturedUpdatesEnabled    = $false # Disabled
$AUSettings.Save()