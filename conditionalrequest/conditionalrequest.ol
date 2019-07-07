include "conditionalrequest.iol"
include "console.iol"
include "time.iol"
include "../config.iol"
include "../calculator/calculator.iol"
include "string_utils.iol"

execution { concurrent }

constants {
    MODIFIED_TIMESTAMP = 300 // seconds = 5 min
}

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort ConditionalRequest {
    Location: ConditionalRequest_Location
    Protocol: http { 
            //debug = true
            //debug.showContent = true
            headers.ifModifiedSince = "ifModifiedSince"
            format = "json" 
            addHeader.header[0] << "lastModified" { .value -> lastModified }
    }
    Interfaces: ConditionalRequestInterface
    Aggregates: Calculator with ConditionalRequestInterface_Extender // Important: has to be of same interface type
}

courier ConditionalRequest {
    [interface CalculatorInterface( request )( response )] {
        
        if ( is_defined( request.ifModifiedSince ) ) {
            length@StringUtils(request.ifModifiedSince)(headerLength);
            if ( headerLength <= 0) {
                getCurrentDateTime@Time( {.format = "dd-MM-yyyy kk:mm:ss"} )( lastModified );
                forward( request )( response )
                response.statusCode = 200
            } else {
                request.ifModifiedSince.format = "dd-MM-yyyy kk:mm:ss";
                getTimestampFromString@Time( request.ifModifiedSince )( timestampFromString );
                timestampFromString = timestampFromString / 1000;

                getCurrentTimeMillis@Time( void )( currentTimestamp );
                currentTimestamp = currentTimestamp / 1000;
                // New data is returned
                if ( (currentTimestamp - timestampFromString) > MODIFIED_TIMESTAMP ) {
                    getCurrentDateTime@Time( {.format = "dd-MM-yyyy kk:mm:ss"} )( lastModified );
                    forward( request )( response )
                    response.statusCode = 200
                } else {
                    response.statusCode = 304
                    // "No New Content. Saving Bandwidth";
                }
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