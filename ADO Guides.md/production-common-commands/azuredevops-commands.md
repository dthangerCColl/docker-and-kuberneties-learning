# Azure Commands Reference for DevOps

## Azure DevOps Workflow Overview

Azure provides a complete suite of tools for managing modern cloud applications
in a DevOps environment. The typical Azure DevOps workflow follows these stages:

1. **Setup**: Configure Azure CLI, authenticate, and set up subscriptions
2. **Infrastructure**: Provision resources using Azure CLI or Infrastructure as
   Code (IaC)
3. **Development**: Build and test applications locally or in Azure DevOps
   Pipelines
4. **Container Management**: Build, push, and manage container images in Azure
   Container Registry
5. **Deployment**: Deploy to Azure App Service, AKS, or Container Instances
6. **CI/CD**: Automate with Azure DevOps Pipelines or GitHub Actions
7. **Monitor**: Track application performance and logs with Azure Monitor and
   Application Insights
8. **Scale & Optimize**: Adjust resources based on demand and cost optimization

### Azure Services for DevOps

- **Azure DevOps**: Complete DevOps toolchain (Repos, Pipelines, Boards,
  Artifacts)
- **Azure Container Registry (ACR)**: Private Docker registry
- **Azure Kubernetes Service (AKS)**: Managed Kubernetes clusters
- **Azure App Service**: PaaS for web apps and APIs
- **Azure Container Instances (ACI)**: Serverless containers
- **Azure Key Vault**: Secrets and certificate management
- **Azure Monitor**: Logging, metrics, and alerts
- **Application Insights**: APM and diagnostics
- **Azure Resource Manager (ARM)**: Infrastructure management

---

## Azure CLI Installation & Setup

### Installation

```bash
# macOS
brew install azure-cli

# Windows (PowerShell)
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Linux (Ubuntu/Debian)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Verify installation
az --version
```

### Login & Configuration

```bash
# Login to Azure
az login

# Login with service principal (CI/CD)
az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant-id>

# Set default subscription
az account set --subscription "My Subscription"

# List subscriptions
az account list --output table

# Show current subscription
az account show
```

---

## 15 Most Used Azure CLI Commands for DevOps

### 1. `az login` / `az account`

**Authenticate and manage Azure subscriptions**

```bash
az login                            # Interactive login
az login --use-device-code          # Device code login
az account list                     # List all subscriptions
az account show                     # Show current subscription
az account set -s "subscription-name"  # Set active subscription
az logout                           # Logout from Azure
```

### 2. `az group`

**Manage resource groups**

```bash
az group create --name myResourceGroup --location eastus
az group list --output table        # List all resource groups
az group show --name myResourceGroup  # Show resource group details
az group delete --name myResourceGroup --yes --no-wait  # Delete resource group
az group export --name myResourceGroup  # Export resource group as template
```

### 3. `az acr`

**Manage Azure Container Registry**

```bash
# Create registry
az acr create --name myregistry --resource-group myRG --sku Basic

# Login to registry
az acr login --name myregistry

# Build and push image
az acr build --registry myregistry --image myapp:v1 .

# List images
az acr repository list --name myregistry --output table

# Show tags
az acr repository show-tags --name myregistry --repository myapp

# Delete image
az acr repository delete --name myregistry --image myapp:v1

# Import image from Docker Hub
az acr import --name myregistry --source docker.io/library/nginx:latest --image nginx:latest
```

### 4. `az aks`

**Manage Azure Kubernetes Service**

```bash
# Create AKS cluster
az aks create --resource-group myRG --name myAKSCluster \
  --node-count 2 --enable-addons monitoring \
  --generate-ssh-keys

# Get credentials for kubectl
az aks get-credentials --resource-group myRG --name myAKSCluster

# List AKS clusters
az aks list --output table

# Scale cluster
az aks scale --resource-group myRG --name myAKSCluster --node-count 3

# Upgrade Kubernetes version
az aks upgrade --resource-group myRG --name myAKSCluster --kubernetes-version 1.28.0

# Start/Stop cluster (save costs)
az aks stop --resource-group myRG --name myAKSCluster
az aks start --resource-group myRG --name myAKSCluster

# Attach ACR to AKS
az aks update --resource-group myRG --name myAKSCluster --attach-acr myregistry
```

### 5. `az webapp`

**Manage Azure App Service web apps**

```bash
# Create App Service plan
az appservice plan create --name myPlan --resource-group myRG --sku B1 --is-linux

# Create web app
az webapp create --resource-group myRG --plan myPlan \
  --name mywebapp --runtime "NODE|18-lts"

# Deploy from local git
az webapp deployment source config-local-git --name mywebapp --resource-group myRG

# Deploy from GitHub
az webapp deployment source config --name mywebapp --resource-group myRG \
  --repo-url https://github.com/user/repo --branch main

# Deploy container
az webapp create --resource-group myRG --plan myPlan \
  --name mywebapp --deployment-container-image-name myregistry.azurecr.io/myapp:v1

# Set app settings
az webapp config appsettings set --resource-group myRG --name mywebapp \
  --settings KEY1=VALUE1 KEY2=VALUE2

# View logs
az webapp log tail --resource-group myRG --name mywebapp

# Restart app
az webapp restart --name mywebapp --resource-group myRG
```

### 6. `az container`

**Manage Azure Container Instances**

```bash
# Create container instance
az container create --resource-group myRG --name mycontainer \
  --image myregistry.azurecr.io/myapp:v1 \
  --cpu 1 --memory 1 \
  --registry-login-server myregistry.azurecr.io \
  --registry-username <username> \
  --registry-password <password> \
  --dns-name-label myapp-unique \
  --ports 80

# List containers
az container list --resource-group myRG --output table

# Show container details
az container show --resource-group myRG --name mycontainer

# View logs
az container logs --resource-group myRG --name mycontainer

# Execute command
az container exec --resource-group myRG --name mycontainer --exec-command "/bin/bash"

# Delete container
az container delete --resource-group myRG --name mycontainer --yes
```

### 7. `az keyvault`

**Manage Azure Key Vault for secrets**

```bash
# Create Key Vault
az keyvault create --name mykeyvault --resource-group myRG --location eastus

# Set secret
az keyvault secret set --vault-name mykeyvault --name "DBPassword" --value "MySecurePassword"

# Get secret
az keyvault secret show --vault-name mykeyvault --name "DBPassword" --query value -o tsv

# List secrets
az keyvault secret list --vault-name mykeyvault --output table

# Delete secret
az keyvault secret delete --vault-name mykeyvault --name "DBPassword"

# Set access policy
az keyvault set-policy --name mykeyvault --object-id <object-id> \
  --secret-permissions get list set delete

# Grant service principal access
az keyvault set-policy --name mykeyvault --spn <app-id> \
  --secret-permissions get list
```

### 8. `az monitor`

**Monitor applications and infrastructure**

```bash
# View activity log
az monitor activity-log list --resource-group myRG --output table

# Create metric alert
az monitor metrics alert create --name HighCPU --resource-group myRG \
  --scopes /subscriptions/{sub-id}/resourceGroups/myRG/providers/Microsoft.Compute/virtualMachines/myVM \
  --condition "avg Percentage CPU > 80" \
  --window-size 5m --evaluation-frequency 1m

# List alerts
az monitor metrics alert list --resource-group myRG --output table

# View logs (Log Analytics)
az monitor log-analytics query --workspace <workspace-id> \
  --analytics-query "AzureActivity | take 10"

# Application Insights
az monitor app-insights component create --app myapp --location eastus \
  --resource-group myRG --application-type web
```

### 9. `az devops`

**Manage Azure DevOps (requires azure-devops extension)**

```bash
# Install extension
az extension add --name azure-devops

# Configure defaults
az devops configure --defaults organization=https://dev.azure.com/myorg project=myproject

# List projects
az devops project list --org https://dev.azure.com/myorg

# List pipelines
az pipelines list --org https://dev.azure.com/myorg --project myproject

# Run pipeline
az pipelines run --name "MyPipeline" --org https://dev.azure.com/myorg --project myproject

# Show pipeline run
az pipelines runs show --id <run-id> --org https://dev.azure.com/myorg --project myproject

# List repos
az repos list --org https://dev.azure.com/myorg --project myproject

# Create pull request
az repos pr create --repository myrepo --source-branch feature --target-branch main \
  --title "My PR" --description "Description"
```

### 10. `az vm` / `az vmss`

**Manage Virtual Machines and Scale Sets**

```bash
# Create VM
az vm create --resource-group myRG --name myVM \
  --image Ubuntu2204 --admin-username azureuser \
  --generate-ssh-keys --size Standard_B2s

# List VMs
az vm list --resource-group myRG --output table

# Start/Stop VM
az vm start --resource-group myRG --name myVM
az vm stop --resource-group myRG --name myVM
az vm deallocate --resource-group myRG --name myVM  # Stop and deallocate (save costs)

# Create VM Scale Set
az vmss create --resource-group myRG --name myScaleSet \
  --image Ubuntu2204 --instance-count 2 \
  --admin-username azureuser --generate-ssh-keys

# Scale VMSS
az vmss scale --resource-group myRG --name myScaleSet --new-capacity 5
```

### 11. `az network`

**Manage networking resources**

```bash
# Create virtual network
az network vnet create --resource-group myRG --name myVNet \
  --address-prefix 10.0.0.0/16 --subnet-name mySubnet --subnet-prefix 10.0.1.0/24

# Create public IP
az network public-ip create --resource-group myRG --name myPublicIP --sku Standard

# Create load balancer
az network lb create --resource-group myRG --name myLB --sku Standard \
  --public-ip-address myPublicIP

# Create application gateway
az network application-gateway create --resource-group myRG \
  --name myAppGateway --capacity 2 --sku Standard_v2 \
  --vnet-name myVNet --subnet mySubnet

# List NSGs
az network nsg list --resource-group myRG --output table

# Create NSG rule
az network nsg rule create --resource-group myRG --nsg-name myNSG \
  --name AllowHTTP --priority 100 --destination-port-ranges 80 --access Allow
```

### 12. `az sql`

**Manage Azure SQL Database**

```bash
# Create SQL server
az sql server create --name myserver --resource-group myRG \
  --location eastus --admin-user myadmin --admin-password MyP@ssw0rd!

# Create database
az sql db create --resource-group myRG --server myserver \
  --name mydb --service-objective S0

# List databases
az sql db list --resource-group myRG --server myserver --output table

# Create firewall rule
az sql server firewall-rule create --resource-group myRG --server myserver \
  --name AllowMyIP --start-ip-address 1.2.3.4 --end-ip-address 1.2.3.4

# Connection string
az sql db show-connection-string --client ado.net --name mydb --server myserver
```

### 13. `az storage`

**Manage Azure Storage accounts**

```bash
# Create storage account
az storage account create --name mystorageaccount --resource-group myRG \
  --location eastus --sku Standard_LRS

# Get connection string
az storage account show-connection-string --name mystorageaccount \
  --resource-group myRG --output tsv

# Create blob container
az storage container create --name mycontainer --account-name mystorageaccount

# Upload blob
az storage blob upload --account-name mystorageaccount --container-name mycontainer \
  --name myfile.txt --file ./myfile.txt

# List blobs
az storage blob list --account-name mystorageaccount --container-name mycontainer \
  --output table

# Generate SAS token
az storage blob generate-sas --account-name mystorageaccount \
  --container-name mycontainer --name myfile.txt \
  --permissions r --expiry 2024-12-31
```

### 14. `az deployment`

**Deploy ARM templates and Bicep**

```bash
# Deploy ARM template to resource group
az deployment group create --resource-group myRG \
  --template-file template.json --parameters @parameters.json

# Deploy Bicep file
az deployment group create --resource-group myRG \
  --template-file main.bicep --parameters env=prod

# Validate template
az deployment group validate --resource-group myRG --template-file template.json

# What-if deployment (preview changes)
az deployment group what-if --resource-group myRG --template-file template.json

# List deployments
az deployment group list --resource-group myRG --output table

# Export template from resource group
az group export --name myRG --include-parameter-default-value > template.json
```

### 15. `az functionapp`

**Manage Azure Functions**

```bash
# Create storage account for Functions
az storage account create --name myfuncstore --resource-group myRG --sku Standard_LRS

# Create Function App
az functionapp create --resource-group myRG --consumption-plan-location eastus \
  --runtime node --runtime-version 18 --functions-version 4 \
  --name myfunctionapp --storage-account myfuncstore

# Deploy from local directory
func azure functionapp publish myfunctionapp

# Set app settings
az functionapp config appsettings set --name myfunctionapp --resource-group myRG \
  --settings "KEY=VALUE"

# View logs
az functionapp log tail --name myfunctionapp --resource-group myRG

# List functions
az functionapp function list --name myfunctionapp --resource-group myRG
```

---

## Azure DevOps CLI Commands

### Prerequisites

```bash
# Install Azure DevOps extension
az extension add --name azure-devops

# Login and set defaults
az login
az devops configure --defaults organization=https://dev.azure.com/yourorg project=yourproject
```

### Repository Management

```bash
# List repositories
az repos list

# Create repository
az repos create --name myrepo

# Clone repository
git clone https://dev.azure.com/yourorg/yourproject/_git/myrepo

# Show repository
az repos show --repository myrepo
```

### Pipeline Management

```bash
# List pipelines
az pipelines list

# Show pipeline
az pipelines show --name "MyPipeline"

# Run pipeline
az pipelines run --name "MyPipeline"

# Show pipeline run
az pipelines runs show --id 123

# List pipeline runs
az pipelines runs list --pipeline-name "MyPipeline" --top 10

# Cancel pipeline run
az pipelines runs cancel --id 123

# Download pipeline artifacts
az pipelines runs artifact download --run-id 123 --artifact-name drop --path ./artifacts
```

### Pull Request Management

```bash
# List pull requests
az repos pr list --repository myrepo --status active

# Create pull request
az repos pr create --repository myrepo \
  --source-branch feature/new-feature \
  --target-branch main \
  --title "Add new feature" \
  --description "This PR adds a new feature"

# Show pull request
az repos pr show --id 101

# Set vote on PR
az repos pr set-vote --id 101 --vote approve

# Complete PR
az repos pr update --id 101 --status completed

# Add reviewer
az repos pr reviewer add --id 101 --reviewers user@example.com
```

### Work Item Management

```bash
# List work items
az boards work-item show --id 123

# Create work item
az boards work-item create --title "Bug: Fix login issue" --type Bug

# Update work item
az boards work-item update --id 123 --state Active

# Query work items
az boards query --wiql "SELECT [System.Id], [System.Title] FROM WorkItems WHERE [System.State] = 'Active'"
```

### Artifact Management

```bash
# List feeds
az artifacts universal list --feed myfeed

# Publish universal package
az artifacts universal publish --feed myfeed --name mypackage --version 1.0.0 \
  --description "My package" --path ./package

# Download universal package
az artifacts universal download --feed myfeed --name mypackage --version 1.0.0 \
  --path ./download
```

---

## Infrastructure as Code (IaC)

### ARM Template Example

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "webAppName": {
      "type": "string",
      "metadata": {
        "description": "Web app name"
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "[concat(parameters('webAppName'), '-plan')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "B1",
        "tier": "Basic"
      },
      "kind": "linux",
      "properties": {
        "reserved": true
      }
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-03-01",
      "name": "[parameters('webAppName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', concat(parameters('webAppName'), '-plan'))]"
      ],
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', concat(parameters('webAppName'), '-plan'))]",
        "siteConfig": {
          "linuxFxVersion": "NODE|18-lts"
        }
      }
    }
  ]
}
```

### Bicep Example

```bicep
param webAppName string
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${webAppName}-plan'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
    }
  }
}

output webAppUrl string = webApp.properties.defaultHostName
```

### Terraform Example

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_service_plan" "plan" {
  name                = "myAppServicePlan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "myWebApp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}
```

---

## CI/CD Pipeline Examples

### Azure Pipelines YAML (azure-pipelines.yml)

```yaml
trigger:
  - main

pool:
  vmImage: "ubuntu-latest"

variables:
  dockerRegistryServiceConnection: "myACRConnection"
  imageRepository: "myapp"
  containerRegistry: "myregistry.azurecr.io"
  dockerfilePath: "$(Build.SourcesDirectory)/Dockerfile"
  tag: "$(Build.BuildId)"

stages:
  - stage: Build
    displayName: Build and push stage
    jobs:
      - job: Build
        displayName: Build job
        steps:
          - task: Docker@2
            displayName: Build and push image to ACR
            inputs:
              command: buildAndPush
              repository: $(imageRepository)
              dockerfile: $(dockerfilePath)
              containerRegistry: $(dockerRegistryServiceConnection)
              tags: |
                $(tag)
                latest

  - stage: Deploy
    displayName: Deploy to AKS
    dependsOn: Build
    jobs:
      - deployment: Deploy
        displayName: Deploy job
        environment: "production"
        strategy:
          runOnce:
            deploy:
              steps:
                - task: KubernetesManifest@0
                  displayName: Deploy to Kubernetes cluster
                  inputs:
                    action: deploy
                    manifests: |
                      $(Pipeline.Workspace)/manifests/deployment.yml
                      $(Pipeline.Workspace)/manifests/service.yml
                    containers: |
                      $(containerRegistry)/$(imageRepository):$(tag)
```

### GitHub Actions Workflow

```yaml
name: Build and Deploy to Azure

on:
  push:
    branches: [main]

env:
  AZURE_WEBAPP_NAME: mywebapp
  AZURE_WEBAPP_PACKAGE_PATH: "."
  NODE_VERSION: "18.x"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: npm install and build
        run: |
          npm install
          npm run build --if-present

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: node-app
          path: .

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: "production"
      url: ${{ steps.deploy.outputs.webapp-url }}

    steps:
      - name: Download artifact
        uses: actions/download-artifact@v3
        with:
          name: node-app

      - name: Login to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Web App
        id: deploy
        uses: azure/webapps-deploy@v2
        with:
          app-name: ${{ env.AZURE_WEBAPP_NAME }}
          package: ${{ env.AZURE_WEBAPP_PACKAGE_PATH }}
```

---

## Best Practices for Azure DevOps

1. **Use Service Principals**: Create service principals for automated
   deployments, not personal accounts
2. **Resource Groups**: Organize resources by environment (dev, staging, prod)
   or application
3. **Naming Conventions**: Use consistent naming (e.g.,
   `{app}-{env}-{resource}`)
4. **Tags**: Tag all resources for cost tracking and organization
5. **Key Vault**: Store all secrets in Azure Key Vault, never in code
6. **Managed Identities**: Use managed identities instead of connection strings
   when possible
7. **Infrastructure as Code**: Use ARM, Bicep, or Terraform for all
   infrastructure
8. **Cost Management**: Set budgets and alerts, use auto-shutdown for non-prod
   VMs
9. **Monitoring**: Enable Application Insights and Azure Monitor for all
   services
10. **RBAC**: Use Role-Based Access Control, follow principle of least privilege
11. **Backup**: Enable backup for critical resources (databases, storage)
12. **Network Security**: Use NSGs, private endpoints, and VNets appropriately

### Service Principal Creation

```bash
# Create service principal
az ad sp create-for-rbac --name "myServicePrincipal" --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group}

# Output (save these values):
# {
#   "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#   "displayName": "myServicePrincipal",
#   "password": "xxxxxxxxxxxxxxxxxxxx",
#   "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# }

# Use in CI/CD
az login --service-principal -u $APP_ID -p $PASSWORD --tenant $TENANT_ID
```

### Resource Tagging

```bash
# Tag resource group
az group update --name myRG --tags Environment=Production CostCenter=IT Owner=TeamA

# Tag individual resource
az resource tag --tags Environment=Dev --resource-group myRG \
  --name myWebApp --resource-type Microsoft.Web/sites

# List resources by tag
az resource list --tag Environment=Production
```

---

## Quick Reference Card

| Task                  | Command                                                                        |
| --------------------- | ------------------------------------------------------------------------------ |
| Login                 | `az login`                                                                     |
| List subscriptions    | `az account list --output table`                                               |
| Create resource group | `az group create --name rg --location eastus`                                  |
| Create ACR            | `az acr create --name registry --resource-group rg --sku Basic`                |
| Build & push to ACR   | `az acr build --registry registry --image app:v1 .`                            |
| Create AKS cluster    | `az aks create --resource-group rg --name aks --node-count 2`                  |
| Get AKS credentials   | `az aks get-credentials --resource-group rg --name aks`                        |
| Create web app        | `az webapp create --resource-group rg --plan plan --name app`                  |
| Create Key Vault      | `az keyvault create --name kv --resource-group rg`                             |
| Set secret            | `az keyvault secret set --vault-name kv --name key --value val`                |
| Run pipeline          | `az pipelines run --name "Pipeline"`                                           |
| Create PR             | `az repos pr create --repository repo --source-branch feature`                 |
| Deploy ARM template   | `az deployment group create --resource-group rg --template-file template.json` |
| View activity logs    | `az monitor activity-log list --resource-group rg`                             |

---

## Common DevOps Scenarios

### Scenario 1: Deploy Containerized App to AKS

```bash
# 1. Create resource group
az group create --name myapp-prod-rg --location eastus

# 2. Create ACR
az acr create --name myappregistry --resource-group myapp-prod-rg --sku Basic

# 3. Build and push image
az acr build --registry myappregistry --image myapp:v1 .

# 4. Create AKS cluster
az aks create --resource-group myapp-prod-rg --name myapp-aks \
  --node-count 2 --enable-addons monitoring --generate-ssh-keys

# 5. Attach ACR to AKS
az aks update --resource-group myapp-prod-rg --name myapp-aks --attach-acr myappregistry

# 6. Get credentials
az aks get-credentials --resource-group myapp-prod-rg --name myapp-aks

# 7. Deploy to Kubernetes
kubectl apply -f deployment.yaml
```

### Scenario 2: Deploy Web App with Secrets from Key Vault

```bash
# 1. Create Key Vault
az keyvault create --name myapp-kv --resource-group myapp-prod-rg

# 2. Add secrets
az keyvault secret set --vault-name myapp-kv --name DBConnectionString --value "Server=..."

# 3. Create web app
az webapp create --resource-group myapp-prod-rg --plan myplan --name mywebapp

# 4. Enable managed identity
az webapp identity assign --resource-group myapp-prod-rg --name mywebapp

# 5. Get managed identity ID
IDENTITY_ID=$(az webapp identity show --resource-group myapp-prod-rg --name mywebapp --query principalId -o tsv)

# 6. Grant Key Vault access
az keyvault set-policy --name myapp-kv --object-id $IDENTITY_ID --secret-permissions get list

# 7. Reference secret in app settings
az webapp config appsettings set --resource-group myapp-prod-rg --name mywebapp \
  --settings DB_CONNECTION="@Microsoft.KeyVault(SecretUri=https://myapp-kv.vault.azure.net/secrets/DBConnectionString/)"
```

### Scenario 3: Set Up Monitoring and Alerts

```bash
# 1. Create Application Insights
az monitor app-insights component create --app myapp --location eastus \
  --resource-group myapp-prod-rg --application-type web

# 2. Get instrumentation key
INSTRUMENTATION_KEY=$(az monitor app-insights component show --app myapp \
  --resource-group myapp-prod-rg --query instrumentationKey -o tsv)

# 3. Configure web app with App Insights
az webapp config appsettings set --resource-group myapp-prod-rg --name mywebapp \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY

# 4. Create metric alert
az monitor metrics alert create --name HighResponseTime \
  --resource-group myapp-prod-rg \
  --scopes /subscriptions/{sub}/resourceGroups/myapp-prod-rg/providers/Microsoft.Web/sites/mywebapp \
  --condition "avg requests/duration > 1000" \
  --window-size 5m --evaluation-frequency 1m \
  --action-group /subscriptions/{sub}/resourceGroups/myapp-prod-rg/providers/microsoft.insights/actionGroups/myActionGroup
```

---

## Troubleshooting Commands

```bash
# View resource events
az monitor activity-log list --resource-group myRG --max-events 50

# Check resource health
az resource show --resource-group myRG --name myResource --resource-type Microsoft.Web/sites

# View deployment history
az deployment group list --resource-group myRG

# Debug failed deployment
az deployment group show --resource-group myRG --name deploymentName

# View web app logs
az webapp log download --resource-group myRG --name myWebApp

# Test connectivity
az network watcher test-connectivity --resource-group NetworkWatcherRG \
  --source-resource /subscriptions/{sub}/resourceGroups/myRG/providers/Microsoft.Compute/virtualMachines/myVM \
  --dest-address www.example.com --dest-port 80
```

---

## Cost Optimization Tips

```bash
# View costs by resource group
az consumption usage list --start-date 2024-01-01 --end-date 2024-01-31

# Stop/Deallocate VMs when not in use
az vm deallocate --resource-group myRG --name myVM

# Stop AKS cluster
az aks stop --resource-group myRG --name myAKSCluster

# Use Azure Advisor recommendations
az advisor recommendation list --output table

# Set up budgets
az consumption budget create --budget-name MyBudget --amount 1000 \
  --time-grain Monthly --start-date 2024-01-01 --end-date 2024-12-31 \
  --resource-group myRG
```

---

## Further Resources

- **Azure CLI Docs**: <https://docs.microsoft.com/cli/azure/>
- **Azure DevOps Docs**: <https://docs.microsoft.com/azure/devops/>
- **Azure Architecture Center**:
  <https://docs.microsoft.com/azure/architecture/>
- **Azure Pricing Calculator**:
  <https://azure.microsoft.com/pricing/calculator/>
- **Azure Status**: <https://status.azure.com/>
- **Azure Updates**: <https://azure.microsoft.com/updates/>
