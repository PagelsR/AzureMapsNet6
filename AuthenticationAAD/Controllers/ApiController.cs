﻿using Azure.Core;
using Azure.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AuthenticationAAD.Controllers
{
    [Authorize]
    public class ApiController : Controller
    {
        /// <summary>
        /// This token provider simplifies access tokens for Azure Resources. It uses the Managed Identity of the deployed resource.
        /// For instance if this application was deployed to Azure App Service or Azure Virtual Machine, you can assign an Azure AD
        /// identity and this library will use that identity when deployed to production.
        /// </summary>
        /// <remarks>
        /// This tokenProvider will cache the token in memory, if you would like to reduce the dependency on Azure AD we recommend
        /// implementing a distributed cache combined with using the other methods available on tokenProvider.
        /// </remarks>
        private static readonly DefaultAzureCredential tokenProvider = new();

        public async Task<IActionResult> GetAzureMapsToken()
        {

            // Managed identities for Azure resources and Azure Maps
            // For the Web SDK to authorize correctly, you still must assign Azure role based access control for the managed identity
            // https://docs.microsoft.com/en-us/azure/azure-maps/how-to-manage-authentication
            var accessToken = await tokenProvider.GetTokenAsync(
                new TokenRequestContext(new[] { "https://atlas.microsoft.com/.default" })
            );

            return new OkObjectResult(accessToken.Token);
        }
    }
}
