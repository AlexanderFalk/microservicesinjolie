include "console.iol"
include "sla.iol"
include "../calculator/calculator.iol"
include "time.iol"
include "../config.iol"
include "slastorageservice.iol"

execution { concurrent }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

outputPort SLAStorageService {
    Location: ServiceLevelAgreementStorage_Location
    Protocol: http { .format = "json"}
    Interfaces: SLAStorageServiceInterface
}

inputPort SLA {
    Location: ServiceLevelAgreement_Location
    Protocol: http { .statusCode -> statusCode, .format = "json"}
    // Important: has to be of same interface type
    Aggregates: 
        Calculator with ServiceLevelInterface_extender,
        SLAStorageService
}


courier SLA {
    [interface CalculatorInterface( request )( response ) ] {
        getCurrentTimeMillis@Time(void)(start);
        forward( request )( response );
        getCurrentTimeMillis@Time(void)(stop);
        responsetime = double(stop - start);
        buildReport@SLAStorageService( { .responsetime = responsetime } )( reportingResponse );
        response.report << reportingResponse
    }
}

init
{
	println@Console( "SLA Middleware Service started" )();
	install( Aborted => nullProcess )
}

main {
    in()
}