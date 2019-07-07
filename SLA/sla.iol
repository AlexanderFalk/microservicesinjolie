include "slastorageservice.iol"

type SLAResponseType: void {
    .report: SLAStorageResponseType
}

interface extender ServiceLevelInterface_extender {
    RequestResponse: *( void )( SLAResponseType ) throws NoSLA ( string )
}
