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
    for ( i = 0, i < 1000, i++ ) {
        global.data[i].chunk = new
    };
    println@Console( "Datachunk Service init has ended!" )()
}

main {
    [datachunk( void )( response ) {
        response.data << global.data
    }]
}