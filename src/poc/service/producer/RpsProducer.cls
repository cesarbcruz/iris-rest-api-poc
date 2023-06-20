Class poc.producer.RpsProducer Extends poc.common.BaseClientMessage
{

ClassMethod send(rps As poc.model.RPS) As %Status
{
   
    Set sc = ..createClient(.client)
    If $$$ISERR(sc) {
        Quit sc
    }

    set exchange = "rps"
    set routingKey = "neogrid"
    set deliveryMode = 2
    do rps.%JSONExportToString(.body)

    set msg = ##class(%External.Messaging.RabbitMQMessage).%New()
    set msg.exchange = exchange
    set msg.routingKey = routingKey
    set msg.deliveryMode = deliveryMode
    do msg.SetEncodedContent(body)

    Set status = client.SendMessage(msg)

    If $$$ISERR(status) {
        Write "Error publishing message to RabbitMQ: "_$SYSTEM.Status.GetErrorText(status)
        Quit $$$ERROR(status)
    } Else {
        Write "Message published to RabbitMQ."
        Quit $$$OK
    }
}

}
