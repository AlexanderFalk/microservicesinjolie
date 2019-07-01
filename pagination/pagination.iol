type PaginationRequestType: void {
    .limit?: int
    .offset?: int
    .page?: int
}
type PaginationResponseType: void{
    .paginationdetails?: PaginationRequestType
}

interface extender PaginationInterface_Extender {
    RequestResponse: *( PaginationRequestType )( PaginationResponseType ) throws NoResponse ( string )
}

interface PaginationInterface {
    RequestResponse:
        pagination( PaginationRequestType )( PaginationResponseType ) throws NoResponse ( string )
}