include "console.iol"
include "time.iol"
include "../config.iol"
include "../dataservice/dataservice.iol"
include "pagination.iol"

execution { concurrent }

constants {
    PAGE_SIZE = 25
}

outputPort DataService {Interfaces: DataServiceInterface}
embedded {Jolie: "../dataservice/dataservice.ol" in DataService}

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
    Aggregates: DataService with PaginationInterface_Extender // Important: has to be of same interface type
}

courier PaginationRequest {
    [interface DataServiceInterface( request )( response )] {
        
        forward( void )( newresponse );
        request.offset = int(request.offset);
        request.limit = int(request.limit);
        request.page = int(request.page);
        if ( request.offset != "" && request.limit != "" ) {
            runUntil = request.offset + request.limit;
            for ( i = request.offset, i < runUntil, i++ ) {
                response.data[i-request.offset].chunk = newresponse.data[i].chunk
            }
            
            response.paginationdetails.limit = request.limit;
            response.paginationdetails.offset = request.offset;
            response.statusCode = 200
            
        } else {
            
            if ( request.page != "" ) {
                runUntil = (PAGE_SIZE * request.page);
                if (request.page != 1) {
                    request.page = (request.page - 1) * PAGE_SIZE
                }
                println@Console(runUntil)();
                for ( i = request.page-1, i < runUntil, i++ ) {
                    response.data[i-request.page+1].chunk = newresponse.data[i].chunk
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