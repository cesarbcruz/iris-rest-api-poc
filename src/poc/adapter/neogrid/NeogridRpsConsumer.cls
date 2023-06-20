Class poc.adapter.neogrid.RpsConsumer Extends poc.common.BaseClientMessage
{

ClassMethod receive() As %Status
{
    Write "receive..."

    Set sc = ..createClient(.client)
    If $$$ISERR(sc) {
        Quit sc
    }

    Set rset = ##class(%External.Messaging.RabbitMQReceiveSettings).%New()
    Set rset.autoAck = 0
    Set queue = "neogrid"

    #dim messages As %ListOfObjects
    Set tSC = client.ReceiveMessage(queue, .messages, rset.ToJSON())
    For i=1:1:messages.Size {
            Set msg = messages.GetAt(i)
            Write "Message: ", msg.ToJSON(), !
    }

    Quit $$$OK
}

}
