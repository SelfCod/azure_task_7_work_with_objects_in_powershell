# Path to the data directory containing JSON files
$dataDirectory = "./data"

# The VM size to search for
$vmSize = "Standard_B2pts_v2"

# Initialize an empty list to store regions where the VM size is found
$availableRegions = @()

# Get all JSON files in the data directory
$jsonFiles = Get-ChildItem -Path $dataDirectory

# Loop through each JSON file
foreach ($file in $jsonFiles) {
    # Construct the full path to the file
    $fullPath = $file.FullName

    # Get the content of the JSON file
    $jsonContent = Get-Content -Path $fullPath -Raw

    # Convert the JSON content to a list of PowerShell objects
    $vmSizes = ConvertFrom-Json -InputObject $jsonContent

    # Search for the VM size in the list of objects
    $foundVM = $vmSizes | Where-Object { $_.Name -eq $vmSize }

    # If the VM size is found, extract the region name and add it to the result list
    if ($foundVM) {
        $regionName = $file.BaseName
        $availableRegions += $regionName
    }
}

# Convert the result list of regions to JSON format
$resultJson = ConvertTo-Json -InputObject $availableRegions -Depth 1

# Define the path for the output JSON file
$resultFilePath = "./result.json"

# Export the result to the result.json file
$resultJson | Out-File -Path $resultFilePath

# Output a message indicating the script has finished
Write-Host "Script finished. Available regions have been exported to result.json"