param skuName string = 'S1'
param location string = resourceGroup().location
param webAppPlanName string
param webSiteName1 string
param webSiteName2 string
param webSiteName3 string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param defaultTags object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: webAppPlanName // app serivce plan name
  location: location // Azure Region
  tags: defaultTags
  properties: {}
  sku: {
    name: skuName
  }
}

resource appService1 'Microsoft.Web/sites@2021-03-01' = {
  name: webSiteName1 // Globally unique app serivce name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
    }
  }
}

resource webSiteAppSettingsStrings1 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: appService1
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    ASPNETCORE_ENVIRONMENT: 'Development'
  }
}

//
// TEST 
//
// Azure Maps Data Reader	Grants access to read map related data
// resource roleAssignmentForAppService1 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
//   name: webSiteName1
//   scope: appService1
//   properties: {
//     principalType: 'ServicePrincipal'
//     principalId: appService1.identity.principalId
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '423170ca-a8f6-4b0f-8487-9e4eb8f49bfa')
//   }
// }

//
// TEST 
//

resource appService2 'Microsoft.Web/sites@2021-03-01' = {
  name: webSiteName2 // Globally unique app serivce name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
    }
  }
}

resource webSiteAppSettingsStrings2 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: appService2
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    ASPNETCORE_ENVIRONMENT: 'Development'
  }
}

resource appService3 'Microsoft.Web/sites@2021-03-01' = {
  name: webSiteName3 // Globally unique app serivce name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
    }
  }
}

resource webSiteAppSettingsStrings3 'Microsoft.Web/sites/config@2021-03-01' = {
  //name: '${webSiteName}/appsettings'
  name: 'appsettings'
  parent: appService3
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    ASPNETCORE_ENVIRONMENT: 'Development'
  }
}

output out_appService1 string = appService1.id
output out_webSiteName1 string = appService1.properties.defaultHostName
output out_appServiceprincipalId1 string = appService1.identity.principalId

output out_appService2 string = appService2.id
output out_webSiteName2 string = appService2.properties.defaultHostName
output out_appServiceprincipalId2 string = appService2.identity.principalId

output out_appService3 string = appService3.id
output out_webSiteName3 string = appService3.properties.defaultHostName
output out_appServiceprincipalId3 string = appService3.identity.principalId
