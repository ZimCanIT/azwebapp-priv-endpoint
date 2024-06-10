$tfmStateRG = "tfmstaterg"
$location = "WestEurope"
$storageAccountName = "zcit2k24tfmwappsacc"
$containerName = "tfstate"

Write-Host "Creating resource group..."
az group create --name $tfmStateRG --location $location

Write-Host "Creating storage account..."
az storage account create `
  --name $storageAccountName `
  --resource-group $tfmStateRG `
  --location $location `
  --sku Standard_LRS

$storageAccountKey = (az storage account keys list --resource-group $tfmStateRG --account-name $storageAccountName --query '[0].value' --output tsv)

Write-Host "Creating container..."
az storage container create `
  --name $containerName `
  --account-name $storageAccountName `
  --account-key $storageAccountKey