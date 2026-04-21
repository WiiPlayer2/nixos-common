using System.CommandLine;
using CliWrap;
using llama_proxy;
using Yarp.ReverseProxy.Configuration;
using Yarp.ReverseProxy.Health;
using Yarp.ReverseProxy.Transforms;
using LanguageExt;

var portOption = new System.CommandLine.Option<int>("--port")
{
    Description = "Port to run the proxy on",
    DefaultValueFactory = _ => 5000,
};
var upstreamOption = new System.CommandLine.Option<Uri>("--upstream")
{
    Description = "Upstream proxy url",
    Required = false,
    CustomParser = x => new Uri(x.Tokens[0].Value),
};
var commandArgument = new Argument<string[]>("command")
{
    Arity = ArgumentArity.OneOrMore,
};
var rootCommand = new RootCommand()
{
    upstreamOption,
    portOption,
    commandArgument,
};

rootCommand.SetAction(async parseResult =>
{
    var builder = WebApplication.CreateBuilder();

    var port = parseResult.GetRequiredValue(portOption);
    var command = parseResult.GetRequiredValue(commandArgument);
    var upstreamUrl = parseResult.GetValue(upstreamOption);
    var downstreamPort = Random.Shared.Next(40000, 40000 + 100);

    if(upstreamUrl is not null)
        try
        {
            Console.WriteLine($"Testing upstream ({upstreamUrl})...");
            using var httpClient = new HttpClient();
            httpClient.Timeout = 5.Seconds();
            var response = await httpClient.GetAsync(upstreamUrl);
            if(!response.IsSuccessStatusCode)
                upstreamUrl = null;
            else
                Console.WriteLine($"Using upstream url ({upstreamUrl})");
        }
        catch
        {
            upstreamUrl = null;
        }

    builder.WebHost.ConfigureKestrel(options =>
    {
        options.ListenLocalhost(port);
    });
    builder.Services.AddReverseProxy()
        .LoadFromMemory(
            BuildRouteConfigs().ToList(),
            BuildClusterConfigs(downstreamPort, upstreamUrl).ToList()
        )
        .AddTransformFactory<CompletionFixTransform>()
        .AddTransforms(builderContext =>
        {
            builderContext.AddResponseTransform(transformContext =>
            {
                transformContext.SuppressResponseBody = transformContext.ProxyResponse is null;
                return ValueTask.CompletedTask;
            });
        });
    builder.Services.AddSingleton<CliService>();
    
    var app = builder.Build();
    string[] commandWithPort =
    [
        ..command,
        "--port",
        downstreamPort.ToString(),
    ];
    var cli = app.Services.GetRequiredService<CliService>();

    app.MapReverseProxy(reverseProxyBuilder =>
    {
        reverseProxyBuilder.Use(async (context, next) =>
        {
            while (true)
            {
                await next();
        
                if (context.Response.StatusCode == StatusCodes.Status502BadGateway)
                {
                    context.Response.Clear();
                    await Task.Delay(5000);
                }
                else
                {
                    break;
                }
            }
        });
    });

    if (upstreamUrl is not null)
    {
        await app.RunAsync();
    }
    else
    {
        await app.StartAsync();
        await Task.WhenAll(app.WaitForShutdownAsync(), WaitCli());
    }

    async Task WaitCli()
    {
        await cli.Run(commandWithPort[0], commandWithPort.Skip(1).ToArray()).ContinueWith(_ => { });
        await app.StopAsync();
    }
});
return rootCommand.Parse(args).Invoke();

IEnumerable<RouteConfig> BuildRouteConfigs()
{
    yield return new RouteConfig
        {
            RouteId = "completions",
            ClusterId = "target",
            Match = new()
            {
                Path = "/v1/chat/completions",
            },
            TimeoutPolicy = "Disable",
        }
        .WithTransform(transform => transform["ApplyCompletionsFix"] = "true");
    yield return new()
    {
        RouteId = "catchall",
        ClusterId = "target",
        Match = new()
        {
            Path = "/{**catchall}",
        },
        TimeoutPolicy = "Disable",
    };
}

IEnumerable<ClusterConfig> BuildClusterConfigs(int downstreamPort, Uri? upstreamUrl)
{
    yield return new()
    {
        ClusterId = "target",
        Destinations = BuildDestinationConfigs(),
        HttpRequest = new()
        {
            ActivityTimeout = 1.Days(), // should be enough :3
        },
    };

    IReadOnlyDictionary<string, DestinationConfig> BuildDestinationConfigs()
    {
        var configs = new Dictionary<string, DestinationConfig>();
        if (upstreamUrl is not null)
            configs["upstream"] = new()
            {
                Address = upstreamUrl.ToString(),
            };
        else
            configs["downstream"] = new()
            {
                Address = $"http://localhost:{downstreamPort}/",
            };
        return configs;
    }
}