type CondReqRequestType {
    .lastModified?: string
}
type CondReqResponseType{
    .isdatanew?: string
}

interface extender ConditionalRequestInterface_Extender {
    RequestResponse: *( CondReqRequestType )( CondReqResponseType ) throws NoResponse ( string )
}

interface ConditionalRequestInterface {
    OneWay:
        conditionalrequest( CondReqResponseType )
}