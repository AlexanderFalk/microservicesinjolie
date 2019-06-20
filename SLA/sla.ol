include "console.iol"
include "sla.iol"
include "../Calculator/calculator.iol"
include "time.iol"
include "../config.iol"

execution { sequential }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort SLA {
    Location: ServiceLevel_Location
    Protocol: http { .statusCode -> statusCode}
    Interfaces: ServiceLevelInterface
    Aggregates: Calculator with ServiceLevelInterface_extender
}

outputPort SLA {
    Location: ServiceLevel_Location
    Protocol: http { .statusCode -> statusCode}
    Interfaces: ServiceLevelInterface
}

courier SLA {
    [calculator( request )( response ) ] {
        getCurrentTimeMillis@Time(void)(start);
        forward( request )( response );
        getCurrentTimeMillis@Time(void)(stop);
        with( response ) { .servicelevel << double(stop - start) }
        
        //calculate@SLA( {.result = response; .servicelevel = } )
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