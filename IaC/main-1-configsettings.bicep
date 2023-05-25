param keyvaultName string
param azuremapname string
param webappName1 string
param webappName2 string
param webappName3 string
//param functionAppName string
// param secret_AzureWebJobsStorageName string
// param secret_WebsiteContentAzureFileConnectionStringName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string

param KeyVault_ClientIdName string

@secure()
param KeyVault_ClientIdValue string

param KeyVault_SubscriptionKeyName string

@secure()
param appServiceprincipalId1 string

@secure()
param appServiceprincipalId2 string

@secure()
param appServiceprincipalId3 string

@secure()
param funcAppServiceprincipalId string

// @secure()
// param secret_AzureWebJobsStorageValue string

param tenant string
//param mysubscription string = subscription();

// Define KeyVault accessPolicies
param accessPolicies array = [
  {
    tenantId: tenant
    objectId: appServiceprincipalId1
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: appServiceprincipalId2
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: appServiceprincipalId3
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: funcAppServiceprincipalId
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
]

// Reference Existing resource
resource existing_keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// Create KeyVault accessPolicies
resource keyvaultaccessmod 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: existing_keyvault
  properties: {
    accessPolicies: accessPolicies
  }
}

// Create KeyVault Secrets
resource secret1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: KeyVault_ClientIdName
  parent: existing_keyvault
  properties: {
    value: KeyVault_ClientIdValue
  }
}

// Reference Existing resource
resource existing_azuremaps 'Microsoft.Maps/accounts@2021-12-01-preview' existing = {
  name: azuremapname
}
var AzureMapsSubscriptionKeyString = existing_azuremaps.listKeys().primaryKey

// Reference Existing resource
resource existing_appService1 'Microsoft.Web/sites@2021-03-01' existing = {
  name: webappName1
}

// Create Web sites/config 'appsettings' - Web App
resource webSiteAppSettingsStrings1 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: existing_appService1
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    WebAppUrl: 'https://${existing_appService1.name}.azurewebsites.net/'
    ASPNETCORE_ENVIRONMENT: 'Development'
    'AzureMaps:ClientId': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_ClientIdName})'
    'AzureMaps:SubscriptionKey': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_SubscriptionKeyName})'
    'Debug Only1': 'ClientId = ${KeyVault_ClientIdValue}'
    'Debug Only2': 'SubscriptionKey = ${AzureMapsSubscriptionKeyString}'
  }
  dependsOn: [
    secret1
  ]
}

// Create KeyVault Secrets
resource secret2 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: KeyVault_SubscriptionKeyName
  parent: existing_keyvault
  properties: {
    value: AzureMapsSubscriptionKeyString
  }
}

// Reference Existing resource
resource existing_appService2 'Microsoft.Web/sites@2021-03-01' existing = {
  name: webappName2
}

// Create Web sites/config 'appsettings' - Web App
resource webSiteAppSettingsStrings2 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: existing_appService2
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    WebAppUrl: 'https://${existing_appService2.name}.azurewebsites.net/'
    ASPNETCORE_ENVIRONMENT: 'Development'
    'AzureMaps:ClientId': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_ClientIdName})'
    'AzureMaps:SubscriptionKey': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_SubscriptionKeyName})'
    'Debug Only1': 'ClientId = ${KeyVault_ClientIdValue}'
    'Debug Only2': 'SubscriptionKey = ${AzureMapsSubscriptionKeyString}'
  }
  dependsOn: [
    secret1
    secret2
  ]
}

// Reference Existing resource
resource existing_appService3 'Microsoft.Web/sites@2021-03-01' existing = {
  name: webappName3
}

// Create Web sites/config 'appsettings' - Web App
resource webSiteAppSettingsStrings3 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: existing_appService3
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    WebAppUrl: 'https://${existing_appService3.name}.azurewebsites.net/'
    ASPNETCORE_ENVIRONMENT: 'Development'
    'AzureMaps:ClientId': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_ClientIdName})'
    'AzureMaps:SubscriptionKey': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${KeyVault_SubscriptionKeyName})'
    'Debug Only1': 'ClientId = ${KeyVault_ClientIdValue}'
    'Debug Only2': 'SubscriptionKey = ${AzureMapsSubscriptionKeyString}'
  }
  dependsOn: [
    secret1
    secret2
  ]
}

// Add role assigment for Service Identity
// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
//
// Azure Maps Data Reader
var azureMapsDataReaderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '423170ca-a8f6-4b0f-8487-9e4eb8f49bfa')

// resource roleAssignmentForAppService2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(existing_appService2.id, azureMapsDataReaderRoleDefinitionId)
//   scope: existing_appService2
//   properties: {
//     principalType: 'ServicePrincipal'
//     principalId: existing_appService2.identity.principalId
//     roleDefinitionId: azureMapsDataReaderRoleDefinitionId
//   }
// }
// resource roleAssignmentForAppService3 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(existing_appService3.id, azureMapsDataReaderRoleDefinitionId)
//   scope: existing_appService3
//   properties: {
//     principalType: 'ServicePrincipal'
//     principalId: existing_appService3.identity.principalId
//     roleDefinitionId: azureMapsDataReaderRoleDefinitionId
//   }
// }


// TBD - https://stackoverflow.com/questions/66993414/how-can-i-add-roles-to-a-resource-group-in-bicep-format
//

// Add role assignment to App Service
resource roleAssignmentForAppService2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  //name: guid(existing_azuremaps.id, existing_appService2.id, azureMapsDataReaderRoleDefinitionId)
  name: guid(existing_appService2.id, azureMapsDataReaderRoleDefinitionId)
  scope: existing_appService2 //resourceGroup()
  properties: {
    principalType: 'ServicePrincipal'
    principalId: existing_appService2.identity.principalId
    roleDefinitionId: azureMapsDataReaderRoleDefinitionId
  }
}

// Add role assignment to App Service
resource roleAssignmentForAppService3 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  //name: guid(existing_azuremaps.id, existing_appService3.id, azureMapsDataReaderRoleDefinitionId)
  name: guid(existing_appService3.id, azureMapsDataReaderRoleDefinitionId)
  scope: existing_appService3 //resourceGroup()
  properties: {
    principalType: 'ServicePrincipal'
    principalId: existing_appService3.identity.principalId
    roleDefinitionId: azureMapsDataReaderRoleDefinitionId
  }
}
