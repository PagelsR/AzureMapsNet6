// Deploy Azure infrastructure for FuncApp + monitoring

// Region for all resources
param location string = resourceGroup().location
param createdBy string = 'Randy Pagels'
param costCenter string = '74f644d3e665'

// Variables for Recommended abbreviations for Azure resource types
// https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
var appInsightsName = 'appi-${uniqueString(resourceGroup().id)}'
var appInsightsWorkspaceName = 'appw-${uniqueString(resourceGroup().id)}'
var appInsightsAlertName = 'responsetime-${uniqueString(resourceGroup().id)}'
var webAppPlanName = 'plan-${uniqueString(resourceGroup().id)}'
var webSiteName1 = 'app1-${uniqueString(resourceGroup().id)}'
var webSiteName2 = 'app2-${uniqueString(resourceGroup().id)}'
var webSiteName3 = 'app3-${uniqueString(resourceGroup().id)}'
var azuremapname = 'maps-${uniqueString(resourceGroup().id)}'
var functionAppName = 'func-${uniqueString(resourceGroup().id)}'
var functionAppServicePlanName = 'funcplan-${uniqueString(resourceGroup().id)}'
var keyvaultName = 'kv-${uniqueString(resourceGroup().id)}'

// KeyVault Secret Names
//param secret_AzureWebJobsStorageName string = 'AzureWebJobsStorage'
param KeyVault_ClientIdName string = 'ClientId'
param KeyVault_SubscriptionKeyName string = 'SubscriptionKey'

// Tags
var defaultTags = {
  App: 'Azure Maps Net 6.0'
  CostCenter: costCenter
  CreatedBy: createdBy
}

// Create Application Insights
module appinsightsmod 'main-1-appinsights.bicep' = {
  name: 'appinsightsdeploy'
  params: {
    location: location
    appInsightsName: appInsightsName
    defaultTags: defaultTags
    appInsightsAlertName: appInsightsAlertName
    appInsightsWorkspaceName: appInsightsWorkspaceName
  }
}

// Create Function App
module functionappmod 'main-1-funcapp.bicep' = {
  name: 'functionappdeploy'
  params: {
    location: location
    functionAppServicePlanName: functionAppServicePlanName
    functionAppName: functionAppName
    defaultTags: defaultTags
  }
  dependsOn:  [
    appinsightsmod
  ]
  
}

// Create Web App
module webappmod './main-1-webapp.bicep' = {
  name: 'webappdeploy'
  params: {
    webAppPlanName: webAppPlanName
    webSiteName1: webSiteName1
    webSiteName2: webSiteName2
    webSiteName3: webSiteName3
    location: location
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    defaultTags: defaultTags
  }
  dependsOn:  [
    appinsightsmod
  ]
}

// Create Azure KeyVault
module keyvaultmod './main-1-keyvault.bicep' = {
  name: keyvaultName
  params: {
    location: location
    vaultName: keyvaultName
    }
 }

 module azuremapsmod 'main-1-azuremaps.bicep' = {
  name: azuremapname
  params: {
    location: location
    azuremapname: azuremapname
  }
 }

 // Create Configuration Entries
module configsettingsmod './main-1-configsettings.bicep' = {
  name: 'configSettings'
  params: {
    keyvaultName: keyvaultName
    KeyVault_ClientIdValue: azuremapsmod.outputs.out_AzureMapsClientId
    KeyVault_ClientIdName: KeyVault_ClientIdName
    tenant: subscription().tenantId
    appServiceprincipalId1: webappmod.outputs.out_appServiceprincipalId1
    appServiceprincipalId2: webappmod.outputs.out_appServiceprincipalId2
    appServiceprincipalId3: webappmod.outputs.out_appServiceprincipalId3
    azuremapname: azuremapname
    webappName1: webSiteName1
    webappName2: webSiteName2
    webappName3: webSiteName3
    KeyVault_SubscriptionKeyName: KeyVault_SubscriptionKeyName
    //functionAppName: functionAppName
    funcAppServiceprincipalId: functionappmod.outputs.out_funcAppServiceprincipalId
    //secret_AzureWebJobsStorageName: secret_AzureWebJobsStorageName
    //secret_AzureWebJobsStorageValue: functionappmod.outputs.out_AzureWebJobsStorage
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    }
    dependsOn:  [
     keyvaultmod
     webappmod
     functionappmod
   ]
 }

// Output Params used for IaC deployment in pipeline
output out_webSiteName1 string = webSiteName1
output out_webSiteName2 string = webSiteName2
output out_webSiteName3 string = webSiteName3
output out_azuremapname string = azuremapname
output out_functionAppName string = functionAppName
