include "console.iol"
include "datachunks.iol"
include "../config.iol"

execution { concurrent }

inputPort DataChunk {
    Location: DataChunks_Location
    Interfaces: DataChunkInterface
}

init {
    println@Console( "Datachunk Service has started!" )();
    [datachunk( void )( response ) {
        for ( i = 0, i < 1000, i++ ) {
            response.data[i].chunk = new
        }
    }]
}

main {
    [datachunk( void )( response ) {
        for ( i = 0, i < 1000, i++ ) {
            println@Console( response.data[i].chunk )()
        }
    }]
}