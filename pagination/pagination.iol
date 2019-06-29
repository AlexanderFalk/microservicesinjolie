type PaginationRequestType: void {
    .docs?: int
    .offset?: int
    .pageNumber?: int
}
type PaginationResponseType: void{
    .response: PaginationRequestType
}

interface extender PaginationInterface_Extender {
    RequestResponse: *( PaginationRequestType )( PaginationResponseType ) throws NoResponse ( string )
}

interface PaginationInterface {
    OneWay:
        conditionalrequest( CondReqResponseType )
}