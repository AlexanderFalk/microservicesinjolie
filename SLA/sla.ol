include "console.iol"
include "sla.iol"
include "../calculator/calculator.iol"
include "time.iol"
include "../config.iol"
include "policyservice.iol"

execution { concurrent }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort SLA {
    Location: ServiceLevelAgreement_Location
    Protocol: http { .statusCode -> statusCode, .format = "json"}
    Interfaces: ServiceLevelInterface
    Aggregates: Calculator with ServiceLevelInterface_extender // Important: has to be of same interface type
}

outputPort SLAStorageService {
    Location: ServiceLevelAgreementStorage_Location
    Protocol: http { .statusCode -> statusCode, .format = json}
    Interfaces: SLAStorageServiceInterface
}

courier SLA {
    [calculator( request )( response ) ] {
        global.number_of_requests++; // Keeping track of every request
        getCurrentTimeMillis@Time(void)(start);
        forward( request )( response );
        getCurrentTimeMillis@Time(void)(stop);
        responsetime = double(stop - start);
        slaReporting@SLAStorageService(responsetime)()
    } 
}

init
{
	println@Console( "SLA Middleware Service started" )();
	install( Aborted => nullProcess );
    global.number_of_breaches = 0;
    global.number_of_requests = 0
}

main {
    
    [slareporting( void )( response ) {
        isTheAvgFailedResponseTimesOK;
        
        response.servicelevelagreement.objectives.avgresponsetime = sum;
        response.servicelevelagreement.objectives.breaches = global.number_of_breaches
    }]
}