type DataChunkResponseType: void {
    .data: void {
        .chunk: string
    }
}

interface DataChunkInterface {
    Request-Response:
        datachunk( void )( DataChunkResponseType ) throws NoDataAvailable( string )
}