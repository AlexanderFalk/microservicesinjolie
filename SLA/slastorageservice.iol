type SLAStorageRequestType: void {
    responsetime?: double
}

type SLAStorageResponseType: void {
    .servicelevelagreement*: void {
        .objectives: void {
            responsetime?: double
            avgresponsetime*: double
            breaches*: int
        }
    }
    .statusCode: int
}

interface SLAStorageServiceInterface {
    RequestResponse:
        slaReporting( SLAStorageRequestType )( SLAStorageResponseType )
}
