Class poc.api.RpsREST Extends poc.api.Base
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get all records of Rps class -->
<Route Url="/rps/all" Method="GET" Call="GetAllRps"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<!-- GET method to return JSON for a given Rps id-->
<Route Url="/rps/:id" Method="GET" Call="GetRps"/>
<!-- Update a Rps with id-->
<Route Url="/rps/:id" Method="PUT" Call="UpdateRps"/>
<!-- Delete a Rps with id-->
<Route Url="/rps/:id" Method="DELETE" Call="DeleteRps"/>
<!-- Create a Rps-->
<Route Url="/rps/" Method="POST" Call="CreateRps"/>
<!-- Create random Rps-->
<Route Url="/rps/gen/:amount" Method="POST" Call="CreateRandomRps"/>
<!-- Get Rps Queue -->
<Route Url="/rps/queue/" Method="GET" Call="GetRpsQueue"/>

</Routes>
}

/// RpsREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

/// Retreive all the records of poc.model.RPS
ClassMethod GetAllRps() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(poc.model.RPS).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write "["
    if rset.%Next() {
        Set Rps = ##class(poc.model.RPS).%OpenId(rset.ID)    
        Do Rps.%JSONExport()
    }
    While rset.%Next() {   
        Write ","
        Set Rps = ##class(poc.model.RPS).%OpenId(rset.ID)    
        Do Rps.%JSONExport()
    }
    Write "]"
    Quit tSC
}

/// Return one record fo poc.model.RPS
ClassMethod GetRps(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set Rps = ##class(poc.model.RPS).%OpenId(id)

    If '$IsObject(Rps) Quit ..Http404()

    Do Rps.%JSONExport()

    Quit tSC
}

/// Creates a new poc.model.RPS record
ClassMethod CreateRps() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set Rps = ##class(poc.model.RPS).%New()
    Set data=%request.Content

    $$$TOE(tSC,Rps.%JSONImport(data))
    $$$TOE(tSC,Rps.%Save())

    Set yourBusinessService = ##class(poc.producer.RpsProducer).%New()

    // Call the OnProcessInput method of the Business Service
    Set status = yourBusinessService.send(Rps)

    // Check the status and handle any errors
    If $$$ISERR(status) {
        // Handle the error condition
        Write "Error: "_$SYSTEM.Status.GetErrorText(status)
    } Else {
        // Process the output message
        Write "Output: "_status
    }

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    
    Do Rps.%JSONExport()

    Quit tSC
}

/// Update a record in poc.model.RPS with id
ClassMethod UpdateRps(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set Rps = ##class(poc.model.RPS).%OpenId(id)
    If '$IsObject(Rps) Return ..Http404()
    Set data=%request.Content

    $$$TOE(tSC,Rps.%JSONImport(data))
    $$$TOE(tSC,Rps.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do Rps.%JSONExport()

    Quit tSC
}

/// Delete a record with id in poc.model.RPS
ClassMethod DeleteRps(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set Rps = ##class(poc.model.RPS).%OpenId(id)
    If '$IsObject(Rps) Return ..Http404()

    $$$TOE(tSC,Rps.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON

    Quit tSC
}

ClassMethod CreateRandomRps(amount As %Integer) As %Status
{
#dim tSC As %Status = $$$OK
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Try {
        set status = ##class(poc.model.RPS).AddTestData(amount)
        $$$ThrowOnError(status)
        Set message = "Created "_amount_" random Rps in poc.model.Rps data"
    } Catch(ex) {
        Set tSC = ex.Code
    }
    Return tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/poc"
  Set swagger.info.title = "InterSystems IRIS POC"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

/// Rps get message queue
ClassMethod GetRpsQueue() As %Status
{
  #dim tSC As %Status = $$$OK
  Set yourBusinessService = ##class(poc.adapter.neogrid.RpsConsumer).%New()
  Set status = yourBusinessService.receive()
  RETURN tSC
}

}
