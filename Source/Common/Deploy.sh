Script path
$(System.DefaultWorkingDirectory)/Azure/Source/Common/Deploy-AzureResourceGroup.ps1

Script arguments
-ResourceGroupName $(CommonResourceGroupName) -ResourceGroupLocation $(CommonResourceGroupLocation) -TemplateFile '.\common.json' -TemplateParametersFile '.\common.parameters.json' -ArtifactStagingDirectory '$(Build.StagingDirectory)'
-ResourceGroupName $(ApplicationResourceGroupName) -ResourceGroupLocation $(ApplicationResourceGroupLocation) -TemplateFile '.\application.json' -TemplateParametersFile '.\production.parameters.json' -ArtifactStagingDirectory '$(Build.StagingDirectory)'


CommonResourceGroupName='Ummati-Common-WestEurope'
CommonResourceGroupLocation='westeurope'
Environment=Common

az group create --name $(CommonResourceGroupName) --location $(CommonResourceGroupLocation) --tags Environment=$(Environment) --verbose
az group deployment create \
  --name "Common-$(date --utc +%Y-%m-%d-%H-%M)" \
  --resource-group $(CommonResourceGroupName) \
  --mode 'Incremental'
  --template-file './Source/Common/common.json' \
  --parameters @'./Source/Common/common.parameters.json' \
  --verbose

az group create --name 'Ummati-Common-WestEurope' --location 'westeurope' --tags Environment=Common --verbose
az group deployment create --name "Common" --resource-group 'Ummati-Common-WestEurope' --mode Incremental --template-file ./Source/Common/common.json --parameters @./Source/Common/common.parameters.json --verbose


ApplicationResourceGroupName='Ummati-Production-WestEurope'
ApplicationResourceGroupLocation='westeurope'
Environment=Production

az group create --name $(ApplicationResourceGroupName) --location $(CommonResourceGroupLocation) --tags Environment=$(Environment) --verbose
az group deployment create \
  --name "Common-$(date --utc +%Y-%m-%d-%H-%M)" \
  --resource-group $(CommonResourceGroupName) \
  --mode 'Incremental'
  --template-file './Source/Common/common.json' \
  --parameters @'./Source/Common/common.parameters.json' \
  --verbose
