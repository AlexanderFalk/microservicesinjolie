type SLAStorageRequestType: void {
    responsetime?: double
}

type SLAStorageResponseType: void {
    .servicelevelagreement?: void {
        .objectives: void {
            responsetime?: double
            avgresponsetime?: double
            breaches?: int
        }
    }
    .statusCode: int
}

type SLAStorageGetReportRequestType: void

type SLAStorageResetReportResponseType: void {
    .msg?: string
}

interface SLAStorageServiceInterface {
    RequestResponse:
        buildReport( SLAStorageRequestType )( SLAStorageResponseType ),
        getReport( SLAStorageGetReportRequestType )( SLAStorageResponseType ),
        reset( void )( SLAStorageResetReportResponseType )
}