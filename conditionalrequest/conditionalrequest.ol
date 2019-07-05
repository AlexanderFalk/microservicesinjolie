include "conditionalrequest.iol"
include "console.iol"
include "time.iol"
include "json_utils.iol"
//include "message_digest.iol"
//include "converter.iol"
include "../config.iol"
include "../calculator/calculator.iol"

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

courier ConditionalRequest {
    [calculator( request )( response )] {

        if ( is_defined( request.lastModified ) ) {
            if ( request.lastModified != "" ) {
                getCurrentDateTime@Time( {.format = "dd-MM-yyyy kk:mm:ss"} )( lastModified );
                forward( request )( response )
            }
            request.lastModified.format = "dd-MM-yyyy kk:mm:ss";
            // .language not supported when looking into the source code
            getTimestampFromString@Time( request.lastModified )( timestampFromString );
            timestampFromString = timestampFromString / 1000;

            getCurrentTimeMillis@Time( void )( currentTimestamp );
            currentTimestamp = currentTimestamp / 1000;
            
            // New data is returned
            if ( (currentTimestamp - timestampFromString) > 300 ) {
                getCurrentDateTime@Time( {.format = "dd-MM-yyyy kk:mm:ss"} )( lastModified );
                forward( request )( response )
            } else {
                statusCode = 304
                // "No New Content. Saving Bandwidth";
            }
        }
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