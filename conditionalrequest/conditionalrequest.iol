type CondReqResponseType{
    .isdatanew: string
}

interface extender ConditionalRequestInterface_Extender {
    RequestResponse: *( void )( CondReqResponseType ) throws NoResponse ( string )
}

interface ConditionalRequestInterface {
    OneWay:
        conditionalrequest( CondReqResponseType )
}