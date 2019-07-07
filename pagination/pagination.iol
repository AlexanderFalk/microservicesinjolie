type PaginationRequestType: void {
    .limit?: int | string
    .offset?: int | string
    .page?: int | string 
}
type PaginationResponseType: void{
    .statusCode: int
    .paginationdetails: PaginationRequestType
}

interface extender PaginationInterface_Extender {
    RequestResponse: *( PaginationRequestType )( PaginationResponseType ) throws NoResponse ( string )
}

interface PaginationInterface {
    RequestResponse:
        pagination( PaginationRequestType )( PaginationResponseType ) throws NoResponse ( string )
}