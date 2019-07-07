include "console.iol"
include "time.iol"
include "file.iol"
include "string_utils.iol"
include "../config.iol"
include "slastorageservice.iol"


execution { sequential }

// Service Level Agreements can be stated in the constants and be overriden when powering the service
constants {
    STORAGE_FILENAME = "storage.json",
    SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME = 5,
    SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME = 15,
    SERVICE_LEVEL_OBJECTIVE_NUMBER_OF_BREACH_RESPONSE_TIMES = 5
}

inputPort SLAStorageService {
    Location: ServiceLevelAgreementStorage_Location
    Protocol: http { .statusCode -> statusCode, .format = "json"}
    Interfaces: SLAStorageServiceInterface
}

/* Calculates the overall average response time */
define calculateTheAvgFailedResponseTime {
    fileresponse.totalresponsetimes = fileresponse.totalresponsetimes + request.responsetime;
    avgsum = fileresponse.totalresponsetimes / fileresponse.numberofrequests
}

/* Every request the SLA report is updated in a JSON file */
define build_sla_reporting {
    readFile@File( { .filename = STORAGE_FILENAME, .format = "json" } )( fileresponse );
    fileresponse.numberofrequests++;
    calculateTheAvgFailedResponseTime;
    fileresponse.avgresponsetime = avgsum

    if ( request.responsetime > SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME ) {
        fileresponse.numberofbreaches++;
        println@Console( "Service Level Objective (Response Time) of " + SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME + " has been breached!" )()
        if ( fileresponse.numberofbreaches >= SERVICE_LEVEL_OBJECTIVE_NUMBER_OF_BREACH_RESPONSE_TIMES ) {
            println@Console("It is time to pay a penalty!")();
            response.statusCode = 418
        }
        
    } else {
        println@Console( "Service Level Objective (Response Time) of " + SERVICE_LEVEL_OBJECTIVE_RESPONSE_TIME + " did not breach!" )()

        if(fileresponse.avgresponsetime < SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME) {
            println@Console( "Service Level Objective (Avg Response Time) of " + SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME + " did not breach!" )()
        } else {
            fileresponse.numberofbreaches++;
            println@Console( "Service Level Objective (Avg Response Time) of " + SERVICE_LEVEL_OBJECTIVE_AVG_RESPONSE_TIME + " did breach!" )()   
        }
    }

    with( file ) {
        .filename = STORAGE_FILENAME;
        .format = "json";
        .content.numberofrequests = fileresponse.numberofrequests;
        .content.numberofbreaches = fileresponse.numberofbreaches;
        .content.avgresponsetime = fileresponse.avgresponsetime;
        .content.totalresponsetimes = fileresponse.totalresponsetimes
    };

    writeFile@File( file )();

    with( objectives ) {
        .responsetime = request.responsetime;
        .avgresponsetime = fileresponse.avgresponsetime;
        .breaches = fileresponse.numberofbreaches
    };

    with( response ) { .servicelevelagreement.objectives << objectives };
    response.statusCode = 200;
    undef ( objectives )
}

/* Gets content from the storage file and returns the values to the client */
define get_sla_reporting {
    readFile@File( { .filename = STORAGE_FILENAME, .format = "json" } )( fileresponse )

    with( objectives ) {
        .avgresponsetime = fileresponse.avgresponsetime;
        .breaches = fileresponse.numberofbreaches
    };
    with( response ) { .servicelevelagreement.objectives << objectives };
    response.statusCode = 200;
    undef ( objectives )
}

define reset {
    println@Console( "Reseting file...")();
    with ( file ) {
        .filename = STORAGE_FILENAME;
        .format = "json";
        .content.numberofrequests = 0;
        .content.numberofbreaches = 0;
        .content.avgresponsetime = 0.0;
        .content.totalresponsetimes = 0
    };

    writeFile@File( file )()
}

/* If no storage file is created, create one and setup the content. Otherwise, the file exists */
init
{
	println@Console( "SLAStorage Middleware Service started. Setting up..." )();
    scope ( file_scope ) {
        install(FileCantBeCreated => 
            println@Console("Issues creating file: " + fileresponse + ". Check for permission errors")()
            throw ( FileCantBeCreated )
        );
        exists@File( STORAGE_FILENAME )( doesFileExist );
        if (doesFileExist) {
            println@Console("File exists: " + STORAGE_FILENAME + ". Setting up...")()
        } else {
            println@Console( "No File with name: " + STORAGE_FILENAME )();
            with ( file ) {
                .filename = STORAGE_FILENAME;
                .format = "json";
                .content.numberofrequests = 0;
                .content.numberofbreaches = 0;
                .content.avgresponsetime = 0.0;
                .content.totalresponsetimes = 0
            };

            writeFile@File( file )();
            println@Console( "Reseting file...")()
        }
        
    };
    println@Console("Service ready")()
	install( Aborted => nullProcess )
}

main {
    
    [buildReport( request )( response ) {
        build_sla_reporting
    }]
    
    [getReport( request )( response ) {
        get_sla_reporting
    }]

    [reset( void )( response ) {
        reset;
        response.msg = "Service Level Agreement Storage has been reset!"
    }]
}