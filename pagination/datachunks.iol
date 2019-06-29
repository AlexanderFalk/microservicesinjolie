type DataChunkResponseType: void {
    .data: void {
        .chunk: string
    }
}

interface DataChunkInterface {
    RequestResponse:
        datachunk( void )( DataChunkResponseType ) throws NoDataAvailable( string )
}