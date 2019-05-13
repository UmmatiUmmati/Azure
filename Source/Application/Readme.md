# Creating a new Deployment

When deploying to a new cluster, follow these steps:

1. Run the following command to create a service principal:

```bash
az ad sp create-for-rbac --name "ummati-<Environment>" --role="Contributor" --scopes="/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>"
```

2. Comment out the following parameters in `<Environment>.parameters.json`:

```bash
kubernetes_servicePrincipalClientId
kubernetes_servicePrincipalClientSecret
```

3. Run the ARM template deployment.

4. Run the following command to give Azure Kubernetes Service (AKS) access to Azure Container Registry (ACR):

```bash
az acr show --resource-group <Resource Group Name> --name <ACR Name> --query "id" --output tsv
az role assignment create --assignee <Client ID> --scope <ACR Resource ID> --role Reader
```

5. Uncomment the following parameters in `<Environment>.parameters.json` to use Azure Key Vault to retrieve them for future deployments of the same resource.

```bash
kubernetes_servicePrincipalClientId
kubernetes_servicePrincipalClientSecret
```

# Upgrading Kubernetes

Get a list of the Kubernetes versions available:

```bash
az aks get-upgrades --resource-group <Resource Group Name> --name <Cluster Name> --output table
```