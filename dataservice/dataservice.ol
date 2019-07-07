include "console.iol"
include "dataservice.iol"
include "../config.iol"

execution { concurrent }

inputPort DataService {
    Location: DataService_Location
    Interfaces: DataServiceInterface
}

init {
    println@Console( "DataService has started!" )();
    for ( i = 0, i < 1000, i++ ) {
        global.data[i].chunk = new
    }
}

main {
    [dataprovider( void )( response ) {
        response.data << global.data
    }]
}