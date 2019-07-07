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
            format = "json" 
    }
    Interfaces: PaginationInterface
    Aggregates: Datachunk with PaginationInterface_Extender // Important: has to be of same interface type
}

courier PaginationRequest {
    [interface DataChunkInterface( request )( response )] {
        
        forward( void )( newresponse );
        request.offset = int(request.offset);
        request.limit = int(request.limit);
        request.page = int(request.page);
        if ( request.offset != "" && request.limit != "" ) {
            
            runs = request.offset + request.limit;

            for ( i = request.offset, i < runs, i++ ) {
                response.data[i-request.offset].chunk = newresponse.data[i].chunk
            }
            
            response.paginationdetails.limit = request.limit;
            response.paginationdetails.offset = request.offset;
            response.statusCode = 200
            
        } else {
            
            if ( request.page != "" ) {
                for ( i = 0, i < #newresponse.data, i++ ) {
                    if ( request.page == i) {
                        response.data[0].chunk = newresponse.data[i].chunk
                        i = #newresponse.data
                    }
                }
                response.paginationdetails.page = int(request.page);
                response.statusCode = 200
                
            }
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