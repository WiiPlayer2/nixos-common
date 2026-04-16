using System.CommandLine;
using CliWrap;
using Yarp.ReverseProxy.Configuration;
using Yarp.ReverseProxy.Transforms;

var portOption = new Option<int>("--port")
{
    Description = "Port to run the proxy on",
    DefaultValueFactory = _ => 5000,
};
var commandArgument = new Argument<string[]>("command")
{
    Arity = ArgumentArity.OneOrMore,
};
var rootCommand = new RootCommand()
{
    portOption,
    commandArgument,
};

rootCommand.SetAction(async parseResult =>
{
    var builder = WebApplication.CreateBuilder();

    var port = parseResult.GetRequiredValue(portOption);
    var command = parseResult.GetRequiredValue(commandArgument);
    var downstreamPort = Random.Shared.Next(40000, 40000 + 100);

    builder.WebHost.ConfigureKestrel(options =>
    {
        options.ListenLocalhost(port);
    });
    builder.Services.AddReverseProxy()
        .LoadFromMemory([
            new RouteConfig
                {
                    RouteId = "downstream-completions",
                    ClusterId = "downstream",
                    Match = new()
                    {
                        Path = "/v1/chat/completions",
                    },
                    TimeoutPolicy = "Disable",
                }
                .WithTransform(transform => transform["ApplyCompletionsFix"] = "true"),
            new()
            {
                RouteId = "downstream-catchall",
                ClusterId = "downstream",
                Match = new()
                {
                    Path = "/{**catchall}",
                },
                TimeoutPolicy = "Disable",
            },
        ], [
            new()
            {
                ClusterId = "downstream",
                Destinations = new Dictionary<string, DestinationConfig>()
                {
                    ["downstream"] = new()
                    {
                        Address = $"http://localhost:{downstreamPort}/",
                    },
                },
            },
        ])
        .AddTransformFactory<CompletionFixTransform>()
        .AddTransforms(builderContext =>
        {
            builderContext.AddResponseTransform(transformContext =>
            {
                transformContext.SuppressResponseBody = transformContext.ProxyResponse is null;
                return ValueTask.CompletedTask;
            });
        });
    
    var app = builder.Build();
    var lifetime = app.Services.GetRequiredService<IHostApplicationLifetime>();
    
    var commandWithPort = command
        .Select(x => x.Replace("__PORT__", downstreamPort.ToString()))
        .ToList();
    var cli = Cli.Wrap(commandWithPort[0])
        .WithArguments(commandWithPort.Skip(1))
        .WithStandardErrorPipe(PipeTarget.ToStream(Console.OpenStandardError()))
        .WithStandardOutputPipe(PipeTarget.ToStream(Console.OpenStandardOutput()))
        .ExecuteAsync(lifetime.ApplicationStopping);

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

    await app.RunAsync();
});
return rootCommand.Parse(args).Invoke();