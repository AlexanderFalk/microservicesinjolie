include "console.iol"
include "sla.iol"
include "SLAStorageService.iol"
include "time.iol"
include "file.iol"
include "../config.iol"

execution { sequential }

// Service Level Agreements can be stated in the constants and be overriden when powering the service
constants {
    SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME = 2,
    SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME = 15,
    SERVICE_LEVEL_OBJECTIVE_NUMBER_OF_BREACH_RESPONSE_TIMES = 5
}

inputPort SLAStorageService {
    Location: ServiceLevelAgreementStorage_Location
    Protocol: http { .statusCode -> statusCode, .format = "json"}
    Interfaces: SLAStorageServiceInterface
}

define calculateTheAvgFailedResponseTime {
    global.total_responsetimes = global.total_responsetimes + objectives.responsetime;
    sum = global.total_responsetimes / global.number_of_requests
}

define sla_reporting {
    
    calculateTheAvgFailedResponseTime;
    objectives.avgresponsetime = sum;
    //objectives.breaches = global.number_of_breaches;
    
    if ( objectives.responsetime > SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME ) {
        //file.filename = "storage.txt"
        //readFile@File(file)( fileresponse );
        //println@Console(fileresponse)();

        //writeFile@File(file)();

        if ( global.number_of_breaches >= SERVICE_LEVEL_OBJECTIVE_NUMBER_OF_BREACH_RESPONSE_TIMES ) {
            println@Console("It is time to pay a penalty!")()    
        }
        println@Console( "Service Level Objective (Response Time) of " + SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME + " has been breached!" )()
    } else {
        if(sum < SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME) {
            println@Console( "Service Level Objective (Response Time) of " + SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME + " did not breach!" )()
            println@Console( "Service Level Objective (Avg Response Time) of " + SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME + " did not breach!" )()
        }
        println@Console( "Service Level Objective (Avg Response Time) of " + SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME + " did breach!" )()   
    }
    with( response ) { .servicelevelagreement.objectives << objectives };
    undef ( objectives )
}

init
{
	println@Console( "SLAStorage Middleware Service started" )();
	install( Aborted => nullProcess );
}

main {
    
    [slaReporting( request )( response ) {
        sla_reporting;
        //response.servicelevelagreement.objectives.avgresponsetime = sum;
        //response.servicelevelagreement.objectives.breaches = global.number_of_breaches
    }]
}