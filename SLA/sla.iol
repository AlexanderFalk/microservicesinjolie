//include "../Calculator/calculator.iol"

type SLAResponseType: void {
    .result: double
    .servicelevel: double
}

interface extender ServiceLevelInterface_extender {
    OneWay: *( SLAResponseType )
}

interface ServiceLevelInterface {
    OneWay:
        calculate( SLAResponseType )
}