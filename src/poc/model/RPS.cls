Class poc.model.RPS Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property code As %Integer;

Property Value As %Decimal(SCALE = 2);

Property ClientId As %Integer;

Property DateTime As %TimeStamp;

ClassMethod AddTestData(amount As %Integer = 10)
{
    d ..Populate(amount)
}

Storage Default
{
<Data name="RPSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
<Value name="4">
<Value>ClientId</Value>
</Value>
<Value name="5">
<Value>DateTime</Value>
</Value>
</Data>
<DataLocation>^poc.model.RPSD</DataLocation>
<DefaultData>RPSDefaultData</DefaultData>
<IdLocation>^poc.model.RPSD</IdLocation>
<IndexLocation>^poc.model.RPSI</IndexLocation>
<StreamLocation>^poc.model.RPSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
