include "datachunks.iol"
include "../config.iol"
include "math.iol"

execution { concurrent }

inputPort DataChunk {
    Location: DataChunks_Location
    Interfaces: DataChunkInterface
}

init {
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