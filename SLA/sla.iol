//include "../Calculator/calculator.iol"

type SLAResponseType: void {
    .result: double
    .servicelevel: double
}

interface extender ProxyInterface_Extender {
	OneWay: *( AuthResponseType ) throws TypeMismatch( string )
}

//interface ServiceLevelInterface {
//    OneWay:
//        calculate( SLAResponseType )
//}