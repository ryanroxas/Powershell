# This script updates tags on Azure Cloud using Azure Cloud Shell. 
# Just answer the prompts for Resource Name, Tag Key, and Tag Value.
# It will add new tags to the resource if the tag is not there, and 
# update the tag with the new value if that is already set on the resource.
##
# Prompt for user input
# Run in Azure Cloud Shell
# Make sure you are already authenticated to run PS Scripts

$resourceGroupName = Read-Host "Enter the resource group name"
$tagKey = Read-Host "Enter the tag key"
$tagValue = Read-Host "Enter the tag value"

# Connect to Azure (uncomment if not already authenticated)
#Connect-AzAccount 

# Get all resources in the specified resource group
$resources = Get-AzResource -ResourceGroupName $resourceGroupName

# Loop through each resource and apply the new tag without overwriting existing ones
foreach ($resource in $resources) {
    Write-Host "Tagging resource: $($resource.Name)"

    # Preserve existing tags
    $currentTags = @{}
    if ($resource.Tags) {
        foreach ($key in $resource.Tags.Keys) {
            $currentTags[$key] = $resource.Tags[$key]
        }
    }

    # Append or update the specific tag key-value
    $currentTags[$tagKey] = $tagValue

    # Apply the updated set of tags
    Set-AzResource -ResourceId $resource.ResourceId -Tags $currentTags -Force
}

Write-Host "Resources in '$resourceGroupName' have been updated with the tag '$tagKey=$tagValue'"