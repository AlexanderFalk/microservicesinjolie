type CondReqRequestType: void {
    .lastModified?: string
}
type CondReqResponseType: void{
    .msg?: string
}

interface extender ConditionalRequestInterface_Extender {
    RequestResponse: *( CondReqRequestType )( CondReqResponseType ) throws NoResponse ( string )
}

interface ConditionalRequestInterface {
    OneWay:
        conditionalrequest( CondReqResponseType )
}