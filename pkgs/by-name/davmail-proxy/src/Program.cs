using System.Text;
using System.Xml;
using System.Xml.Serialization;
using Microsoft.AspNetCore.Http.Features;
using Yarp.ReverseProxy.Forwarder;
using Yarp.ReverseProxy.Transforms;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddTransforms(context =>
    {
        if (context.Route.RouteId != "calendar") return;

        context.AddResponseTransform(TransformCalendarResponse);
    })
    ;

var app = builder.Build();

app.MapReverseProxy(reverseProxyApp => { reverseProxyApp.Use(TransformMiddleware); });

app.Run();

async Task TransformMiddleware(HttpContext context, RequestDelegate next)
{
    var proxyFeature = context.GetReverseProxyFeature();

    if (proxyFeature.Route.Config.RouteId != "calendar")
    {
        await next(context);
        return;
    }

    var bufferedBody = new MemoryStream();
    await context.Request.Body.CopyToAsync(bufferedBody);
    bufferedBody.Position = 0;
    context.Request.Body = bufferedBody;

    await next(context);
}

async ValueTask TransformCalendarResponse(ResponseTransformContext context)
{
    if (context.ProxyResponse is null || !context.ProxyResponse.IsSuccessStatusCode) return;

    using var requestBuffer = new MemoryStream();
    context.HttpContext.Request.Body.Position = 0;
    await context.HttpContext.Request.Body.CopyToAsync(requestBuffer);
    requestBuffer.Position = 0;

    var debug___ = Encoding.UTF8.GetString(requestBuffer.ToArray());

    await using var contentStream =
        await context.ProxyResponse.Content.ReadAsStreamAsync(context.CancellationToken);
    var xmlDocument = new XmlDocument();
    xmlDocument.Load(contentStream);
    var namespaceManager = new XmlNamespaceManager(xmlDocument.NameTable);
    namespaceManager.AddNamespace("D", "DAV:");
    namespaceManager.AddNamespace("C", "urn:ietf:params:xml:ns:caldav");

    // var content = await context.ProxyResponse.Content.ReadAsStringAsync(context.CancellationToken);

    if (context.HttpContext.Request.Method == "PROPFIND")
    {
        var xmlRequestSerializer = new XmlSerializer(typeof(Propfind));
        var requestPropfind = (Propfind)xmlRequestSerializer.Deserialize(requestBuffer)!;

        var responses = xmlDocument.SelectNodes("//D:response", namespaceManager)!;
        foreach (XmlNode response in responses)
            if (requestPropfind.Prop.CurrentUserPrincipal is not null)
                await EnrichUserPrincipalUrlResponse(xmlDocument, namespaceManager, response,
                    context.CancellationToken);
            else if (requestPropfind.Prop.CalendarHomeSet is not null)
                await EnrichCalendarHomeUrlResponse(xmlDocument, namespaceManager, response, context.CancellationToken);
            else
                await EnrichResponse(xmlDocument, response, namespaceManager, context.CancellationToken);
        // response.ParentNode!.ReplaceChild(response, transformedResponse);
    }

    using var buffer = new MemoryStream();
    await using var xmlWriter = new XmlTextWriter(buffer, new UTF8Encoding(false));
    xmlDocument.WriteTo(xmlWriter);
    xmlWriter.Flush();

    var _debug = Encoding.UTF8.GetString(buffer.ToArray());

    buffer.Position = 0;
    await buffer.CopyToAsync(context.HttpContext.Response.Body, context.CancellationToken);
    await context.HttpContext.Response.Body.FlushAsync(context.CancellationToken);

    static async ValueTask EnrichUserPrincipalUrlResponse(XmlDocument document, XmlNamespaceManager namespaceManager,
        XmlNode proxyResponse, CancellationToken cancellationToken)
    {
        var prop = proxyResponse.SelectSingleNode("./D:propstat/D:prop", namespaceManager)!;

        if (prop.SelectSingleNode("./D:user-principal", namespaceManager) is not null) return;

        var currentUserPrincipal = prop.AppendChild(document.CreateNode(XmlNodeType.Element, "D",
            "current-user-principal", namespaceManager.LookupNamespace("D")))!;
        var currentUserPrincipalHref = currentUserPrincipal.AppendChild(document.CreateNode(XmlNodeType.Element, "D",
            "href", namespaceManager.LookupNamespace("D")))!;
        currentUserPrincipalHref.InnerText = "/users/waldemar.tomme@Bluehands.de/calendar/";
    }

    static async ValueTask EnrichCalendarHomeUrlResponse(XmlDocument document, XmlNamespaceManager namespaceManager,
        XmlNode proxyResponse, CancellationToken cancellationToken)
    {
        var prop = proxyResponse.SelectSingleNode("./D:propstat/D:prop", namespaceManager)!;

        if (prop.SelectSingleNode("./C:calendar-home-set", namespaceManager) is not null) return;

        var calendarHomeSet = prop.AppendChild(document.CreateNode(XmlNodeType.Element, "C", "calendar-home-set",
            namespaceManager.LookupNamespace("C")))!;
        var calendarHomeSetHref = calendarHomeSet.AppendChild(document.CreateNode(XmlNodeType.Element, "D", "href",
            namespaceManager.LookupNamespace("D")))!;
        calendarHomeSetHref.InnerText = "/";
    }

    static async ValueTask EnrichResponse(XmlDocument document, XmlNode proxyResponse,
        XmlNamespaceManager namespaceManager, CancellationToken cancellationToken)
    {
        var prop = proxyResponse.SelectSingleNode("./D:propstat/D:prop", namespaceManager)!;

        // var calendarHomeSet = prop.AppendChild(NewElement("C", "calendar-home-set"))!;
        // var calendarHomeSetHref = calendarHomeSet.AppendChild(NewElement("D", "href"))!;
        // calendarHomeSetHref.InnerText = "http://localhost:1081/users/waldemar.tomme@Bluehands.de/calendar/";

        if (proxyResponse.SelectSingleNode(".//C:supported-calendar-component-set", namespaceManager) is not
            { } supportedCalendarComponentSet) return;

        foreach (var xmlNode in proxyResponse.SelectNodes(".//C:comp", namespaceManager)!
                     .OfType<XmlNode>()
                     .Where(x => x.Attributes!["name"]!.Value != "VEVENT"))
            xmlNode.ParentNode!.RemoveChild(xmlNode);

        // var supportedCalendarComponentSet = prop.AppendChild(NewElement("C", "supported-calendar-component-set"))!;
        // var vevent = supportedCalendarComponentSet.AppendChild(NewElement("C", "comp"))!;
        // vevent.Attributes!.Append(document.CreateAttribute("C", "name", namespaceManager.LookupPrefix("C"))).Value = "VEVENT";
        //
        // SetSimpleProp("D", "displayname", "Display Name");

        // var resourceType = prop.AppendChild(NewElement("D", "resourcetype"))!;
        // resourceType.AppendChild(NewElement("C", "calendar"));

        // SetSimpleProp("C", "calendar-data", """
        //                                     BEGIN:VCALENDAR
        //                                     VERSION:2.0
        //                                     BEGIN:VTIMEZONE
        //                                     LAST-MODIFIED:20040110T032845Z
        //                                     TZID:US/Eastern
        //                                     BEGIN:DAYLIGHT
        //                                     DTSTART:20000404T020000
        //                                     RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
        //                                     TZNAME:EDT
        //                                     TZOFFSETFROM:-0500
        //                                     TZOFFSETTO:-0400
        //                                     END:DAYLIGHT
        //                                     BEGIN:STANDARD
        //                                     DTSTART:20001026T020000
        //                                     RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
        //                                     TZNAME:EST
        //                                     TZOFFSETFROM:-0400
        //                                     TZOFFSETTO:-0500
        //                                     END:STANDARD
        //                                     END:VTIMEZONE
        //                                     BEGIN:VEVENT
        //                                     DTSTART;TZID=US/Eastern:20060102T120000
        //                                     DURATION:PT1H
        //                                     RRULE:FREQ=DAILY;COUNT=5
        //                                     SUMMARY:Event #2
        //                                     UID:00959BC664CA650E933C892C@example.com
        //                                     END:VEVENT
        //                                     BEGIN:VEVENT
        //                                     DTSTART;TZID=US/Eastern:20060104T140000
        //                                     DURATION:PT1H
        //                                     RECURRENCE-ID;TZID=US/Eastern:20060104T120000
        //                                     SUMMARY:Event #2 bis
        //                                     UID:00959BC664CA650E933C892C@example.com
        //                                     END:VEVENT
        //                                     BEGIN:VEVENT
        //                                     DTSTART;TZID=US/Eastern:20060106T140000
        //                                     DURATION:PT1H
        //                                     RECURRENCE-ID;TZID=US/Eastern:20060106T120000
        //                                     SUMMARY:Event #2 bis bis
        //                                     UID:00959BC664CA650E933C892C@example.com
        //                                     END:VEVENT
        //                                     END:VCALENDAR
        //                                     """);

        void SetSimpleProp(string prefix, string name, string value)
        {
            var valueNode = NewElement(prefix, name);
            valueNode.InnerText = value;
            prop.AppendChild(valueNode);
        }

        XmlElement NewElement(string prefix, string name)
        {
            var @namespace = namespaceManager.LookupNamespace(prefix);
            return (XmlElement)document.CreateNode(XmlNodeType.Element, prefix, name, @namespace);
        }
    }
}

internal static class Constants
{
    public const string NAMESPACE_DAV = "DAV:";

    public const string NAMESPACE_CALDAV = "urn:ietf:params:xml:ns:caldav";
}

[XmlRoot("propfind", Namespace = Constants.NAMESPACE_DAV)]
public class Propfind
{
    [XmlElement(ElementName = "prop", Namespace = Constants.NAMESPACE_DAV)]
    public required Prop Prop { get; set; }
}

[XmlRoot("prop", Namespace = Constants.NAMESPACE_DAV)]
public class Prop
{
    [XmlElement(ElementName = "current-user-principal", Namespace = Constants.NAMESPACE_DAV)]
    public object? CurrentUserPrincipal { get; set; }

    [XmlElement(ElementName = "calendar-home-set", Namespace = Constants.NAMESPACE_CALDAV)]
    public object? CalendarHomeSet { get; set; }
}