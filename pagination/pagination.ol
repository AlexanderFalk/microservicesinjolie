include "console.iol"
include "time.iol"

include "../config.iol"
include "datachunks.iol"
include "pagination.iol"

execution { concurrent }

outputPort Datachunk {Interfaces: DataChunkInterface}
embedded {Jolie: "datachunks.ol" in Datachunk}

inputPort PaginationRequest {
    Location: Pagination_Location
    Protocol: http {
            //debug = true
            //debug.showContent = true
            headers.limit = "limit"
            headers.offset = "offset"
            headers.page = "page"
            statusCode -> statusCode
            format = "json" 
            addHeader.header[0] << "lastModified" { .value -> lastModified }
    }
    Interfaces: PaginationInterface
    Aggregates: Datachunk with PaginationInterface_Extender // Important: has to be of same interface type
}

courier PaginationRequest {
    [datachunk( request )( response )] {
        
        with ( response ) {
            .paginationdetails.limit = request.limit
            .paginationdetails.offset = request.offset
//            .paginationdetails.page = request.page
        };
        forward( void )( newresponse );
        runs = response.paginationdetails.offset + response.paginationdetails.limit;
        println@Console(runs)();
        for ( i = response.paginationdetails.offset, i < runs, i++ ) {
            if ( is_defined( response.paginationdetails.page ) ) {
                
                if (i == response.paginationdetails.page) {
                    println@Console("Page defined")()
                }
            }
            response.data[i].chunk = newresponse.data[i].chunk
        }
    }
}

init {
    println@Console( "Pagination Service has started!" )();
    install ( Aborted => nullProcess )
}

main {
    [pagination( request )( response ) {
        println@Console("This is the pagination response")()
    }]
}