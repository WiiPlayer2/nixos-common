using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Yarp.ReverseProxy.Transforms;
using Yarp.ReverseProxy.Transforms.Builder;

public class CompletionFixTransform : ITransformFactory
{
    public bool Validate(TransformRouteValidationContext context,
        IReadOnlyDictionary<string, string> transformValues) => true;

    public bool Build(TransformBuilderContext context, IReadOnlyDictionary<string, string> transformValues)
    {
        if (!transformValues.TryGetValue("ApplyCompletionsFix", out _))
            return false;

        context.AddRequestTransform(async transformContext =>
        {
            using var reader = new StreamReader(transformContext.HttpContext.Request.Body);
            var body = await reader.ReadToEndAsync();
            if (!string.IsNullOrEmpty(body))
            {
                var bodyJson = JsonSerializer.Deserialize<JsonObject>(body)!;
                var messages = bodyJson["messages"]!.AsArray();
                var systemMessages = messages.Where(m => m["role"]!.GetValue<string>() == "system").ToList();
                if (systemMessages.Any())
                {
                    var otherMessages = messages.Where(m => m["role"]!.GetValue<string>() != "system").ToList();
                    var newSystemMessage = new JsonObject([
                         new("role", "system"),
                         new("content", string.Join("\n\n", systemMessages.Select(m => m["content"]!.GetValue<string>()))),
                    ]);
                    bodyJson["messages"] = new JsonArray([newSystemMessage, ..otherMessages.Select(x => x.DeepClone())]);
                }

                var newBody = bodyJson.ToJsonString();
                
                var bytes = Encoding.UTF8.GetBytes(newBody);
                // Change Content-Length to match the modified body, or remove it
                transformContext.HttpContext.Request.Body = new MemoryStream(bytes);
                // Request headers are copied before transforms are invoked, update any
                // needed headers on the ProxyRequest
                transformContext.ProxyRequest.Content!.Headers.ContentLength =
                    bytes.Length;
            }
        });
        return true;
    }
}