# Instructions

When deploying to an existing cluster, deploy as normal. When deploying to a new cluster, follow these steps:

1. Delete all Kubernetes resources from `application.json` and the `<environment>.parameters.json` file.
2. Run the following command to create a service principal:

```
az ad sp create-for-rbac --name "ummati-<Environment>" --role="Contributor" --scopes="/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>"
```

3. Store the Client ID and Client Secret in the newly created Azure Key Vault as:

```
AzureKubernetesServiceServicePrincipalClientId
AzureKubernetesServiceServicePrincipalClientSecret
```

4. Bring back all Kubernetes resources in `application.json` and the `<environment>.parameters.json` file.
5. Run the following command to give AKS access to ACR:

```
az acr show --resource-group <Resource Group Name> --name <ACR Name> --query "id" --output tsv
az role assignment create --assignee <Client ID> --scope <ACR Resource ID> --role Reader
```