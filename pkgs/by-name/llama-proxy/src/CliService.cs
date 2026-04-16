using CliWrap;

namespace llama_proxy;

public class CliService(IHostApplicationLifetime applicationLifetime, ILogger<CliService> logger)
{
    public async Task Run(string exe, string[] args)
    {
        await Cli.Wrap(exe)
            .WithArguments(args)
            .WithStandardErrorPipe(PipeTarget.ToDelegate(OnErrorOutput))
            .ExecuteAsync(applicationLifetime.ApplicationStopped, applicationLifetime.ApplicationStopping);
    }

    private void OnErrorOutput(string line)
    {
        if(line.Contains("prompt processing"))
            logger.LogInformation(line);
        else if(line.StartsWith("load_tensors:"))
            logger.LogInformation(line);
        else
            logger.LogTrace(line);
    }
}
