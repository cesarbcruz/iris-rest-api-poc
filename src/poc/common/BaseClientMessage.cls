Class poc.common.BaseClientMessage Extends %RegisteredObject
{

ClassMethod createClient(ByRef %client As %External.Messaging.RabbitMQSettings) As %Status
{
    Set settings = ##class(%External.Messaging.RabbitMQSettings).%New()
    Set settings.username = "guest"
    Set settings.password = "guest"
    Set settings.host = "rabbitmq"
    Set settings.port = 5672

    Set %client = ##class(%External.Messaging.Client).CreateClient(settings, .tSC)
    If $$$ISERR(tSC) {
        Quit $$$ERROR("Error create client: "_tSC.Description)
    }

    Quit $$$OK
}

}
