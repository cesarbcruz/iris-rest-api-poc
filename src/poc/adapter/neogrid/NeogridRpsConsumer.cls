Class poc.adapter.neogrid.RpsConsumer Extends poc.common.BaseClientMessage
{

ClassMethod receive(ByRef list As %Library.ListOfObjects) As %Status
{
    Set sc = ..createClient(.client)
    If $$$ISERR(sc) {
        Quit sc
    }

    Set rset = ##class(%External.Messaging.RabbitMQReceiveSettings).%New()
    Set rset.autoAck = 0
    Set queue = "neogrid"

    $$$ThrowOnError(client.ReceiveMessage(queue, .messages, rset.ToJSON()))
    $$$ThrowOnError(client.Close())
    For i = 1:1:messages.Count() {
        Set obj = messages.GetAt(i)
        Set data = obj.encodedContent.Read()
        Set Rps = ##class(poc.model.RPS).%New()
        $$$TOE(tSC,Rps.%JSONImport(data))
        Do obj.encodedContent.%Close()
        Do list.Insert(Rps)
    }

    Quit $$$OK
}

}
