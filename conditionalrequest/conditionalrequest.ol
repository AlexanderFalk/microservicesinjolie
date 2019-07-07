include "conditionalrequest.iol"
include "console.iol"
include "time.iol"
include "../config.iol"
include "../dataservice/dataservice.iol"
include "string_utils.iol"

execution { concurrent }

constants {
    MODIFIED_TIMESTAMP = 300 // seconds = 5 min
}

outputPort DataService {Interfaces: DataServiceInterface}
embedded {Jolie: "../dataservice/dataservice.ol" in DataService}

inputPort ConditionalRequest {
    Location: ConditionalRequest_Location
    Protocol: http { 
            //debug = true
            //debug.showContent = true
            headers.("If-Modified-Since") = "If-Modified-Since"
            format = "json" 
            addHeader.header[0] << "Last-Modified" { .value -> lastModified }
    }
    Interfaces: ConditionalRequestInterface
    Aggregates: DataService with ConditionalRequestInterface_Extender // Important: has to be of same interface type
}

courier ConditionalRequest {
    [interface DataServiceInterface( request )( response )] {
        
        if ( is_defined( request.("If-Modified-Since") ) ) {
            length@StringUtils(request.("If-Modified-Since"))(headerLength);
            if ( headerLength <= 0) {
                getCurrentDateTime@Time( {.format = "dd-MM-yyyy kk:mm:ss"} )( lastModified );
                forward( request )( response )
                response.statusCode = 200
            } else {
                
                request.("If-Modified-Since").format = "dd-MM-yyyy kk:mm:ss";
                getTimestampFromString@Time( request.("If-Modified-Since") )( timestampFromString );
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