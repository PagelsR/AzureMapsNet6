using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using SubscriptionKey.Models;
using System.Diagnostics;

namespace SubscriptionKey.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _configuration;

        // IConfiguration Configuration
        public HomeController(ILogger<HomeController> logger, IConfiguration Configuration)
        {
            _logger = logger;
            _configuration = Configuration;
        }

        public IActionResult Index()
        {
            // Save SubscriptionKey from Configuration Settings
            ViewData["SubscriptionKey"] = _configuration.GetSection("AzureMaps").GetValue<string>("SubscriptionKey");

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}