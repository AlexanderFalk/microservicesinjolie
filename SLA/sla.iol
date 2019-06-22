type SLAResponseType: void {
    .servicelevelagreement*: void {
        .objectives: void {
            responsetime*: double // Only valuable at a specific call
            avgresponsetime*: double
            breaches*: int
        }
    }
}

type SLAReportResponseType: void {
    .servicelevelagreement*: void {
        .objectives: void {
            avgresponsetime*: double
            breaches*: int
        }
    }
}

interface extender ServiceLevelInterface_extender {
    RequestResponse: *( void )( SLAResponseType ) throws NoSLA ( string )
}

interface ServiceLevelInterface {
    RequestResponse:
        slareporting( void )( SLAReportResponseType )
}
