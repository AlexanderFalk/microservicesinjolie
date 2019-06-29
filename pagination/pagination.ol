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
            headers.docs = "no_docs"
            headers.offset = "offset"
            headers.pagenumber = "page_no"
            statusCode -> statusCode
            format = "json" 
            addHeader.header[0] << "lastModified" { .value -> lastModified }
    }
    Interfaces: PaginationInterface
    Aggregates: Datachunk with PaginationInterface_Extender // Important: has to be of same interface type
}

courier PaginationRequest {
    [datachunk( request )( response )] {
        
        forward( void )( response )
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