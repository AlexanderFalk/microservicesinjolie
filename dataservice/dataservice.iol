type DataServiceResponseType: void {
    .data*: void {
        .chunk: string
    }
}

interface DataServiceInterface {
    RequestResponse:
        dataprovider( void )( DataServiceResponseType ) throws NoDataAvailable( string )
}