include "conditionalrequest.iol"
include "console.iol"
include "time.iol"
include "json_utils.iol"
//include "message_digest.iol"
//include "converter.iol"
include "../config.iol"
include "../Calculator/calculator.iol"

execution { concurrent }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort ConditionalRequest {
    Location: ConditionalRequest_Location
    Protocol: http { 
            //debug = true
            //debug.showContent = true
            headers.lastModified = "lastModified"
            statusCode -> statusCode
            format = "json" 
            addHeader.header[0] << "lastModified" { .value -> lastModified }
    }
    Interfaces: ConditionalRequestInterface
    Aggregates: Calculator with ConditionalRequestInterface_Extender // Important: has to be of same interface type
}

/*define renewData {
    stringToRaw@Converter( string(request) )( covertedOutput );
    println@Console( "" + convertedOutput + "" )();
    md5@MessageDigest( { .radix = covertedOutput } )( newResponse );
    println@Console( newResponse )();
    println@Console( "Checksum: " + checksum )()
} */

courier ConditionalRequest {
    [calculator( request )( response )] {
        getJsonString@JsonUtils( request )( jsonresponse );
        println@Console("JSON Response: " + request.lastModified)();
        getCurrentTimeMillis@Time( void )( timestamp );
        lastModified = timestamp
        //timestamp.format = "HH:mm:ss";
        getDateTime@Time( timestamp )( lastModified );
        getTimeDiff@Time( { .time2 = request.lastModified, .time1 = lastModified  } )( timeDifference );
        println@Console("Date Difference: " + timeDifference )();
        forward( request )( response )
    }
}

init {
    println@Console( "Conditional Request Service has started!" )();
    install ( Aborted => nullProcess )
}

main {
    [conditionalrequest( response )] {
        println@Console("This is the response")()
    }
}