include "console.iol"
include "sla.iol"
include "../Calculator/calculator.iol"
include "time.iol"
include "../config.iol"

inputPort SLA {
    Location: ServiceLevel_Location
    Protocol: http { .statusCode -> statusCode}
    Interfaces: ServiceLevelInterface
    Aggregates: Calculator
}

courier SLA {
    [calculator( request )( response ) {
        println@Console("Hello, I am the courier process")();
        start = getCurrentTimeMillis@Time()();
        forward( request )( response );
        response.servicelevel = getCurrentTimeMillis@Time()() - start
    }]
}

init
{
	println@Console( "SLA started" )();
	install( Aborted => nullProcess )
}

main {
    [timeToRespond( request )( response )] { println@Console("Work")() }
}