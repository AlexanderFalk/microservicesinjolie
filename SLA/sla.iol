//include "../Calculator/calculator.iol"

type SLAResponseType: void {
    .result: double
    .servicelevel: double
}

interface ServiceLevelInterface {
    OneWay:
        calculate( SLAResponseType )
}