
# This script updates tags on Azure Cloud using Azure Cloud Shell. 
# Just answer the prompts for Resource Name, Tag Key, and Tag Value.
# It will add a new tags to the resource if the tag is not there, and 
# update the tags with the new value if that is already set on the resource.
# Make sure to follow the format: key1=value1;key2=value2 when prompted for tags.
##
# Prompt for user input
# Run in Azure Cloud Shell
# Make sure you are already authenticated to run PS Scripts

$resourceGroupName = Read-Host "Enter the resource group name"
$tagInput = Read-Host "Enter tags (format: key1=value1;key2=value2)"

# Parse tag input into a hashtable
$tagPairs = $tagInput -split ';'
$newTags = @{}
foreach ($pair in $tagPairs) {
    $kv = $pair -split '=', 2
    if ($kv.Length -eq 2) {
        $newTags[$kv[0].Trim()] = $kv[1].Trim()
    }
}

# Get resources in the specified resource group
$resources = Get-AzResource -ResourceGroupName $resourceGroupName

# Apply multiple tags without overwriting existing ones
foreach ($resource in $resources) {
    Write-Host "Tagging resource: $($resource.Name)"

    $currentTags = @{}
    if ($resource.Tags) {
        $currentTags += $resource.Tags
    }

    foreach ($key in $newTags.Keys) {
        $currentTags[$key] = $newTags[$key]
    }

    Set-AzResource -ResourceId $resource.ResourceId -Tags $currentTags -Force
}

Write-Host "Resources in '$resourceGroupName' have been updated with the provided tags."
