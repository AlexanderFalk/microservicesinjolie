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
        totaltime = stop - start;
        with ( response ) { .servicelevel << totaltime}
        println@Console(stop - start + "ms")()
        //calculate@SLA( {.result = response; .servicelevel = double(stop - start)} )
    } 
}

init
{
	println@Console( "SLA Middleware Service started" )();
	install( Aborted => nullProcess )
}

main {
    [calculate( sla )] {
        sla.result = response; 
        sla.servicelevel = double(stop - start)
    }
    //[calculate( slaresponse )] {
    //   println@Console( "Done" )()
        //calculator@Calculator( request )( response );
        //slaresponse.result = response;
        //slaresponse.servicelevel = 22.0
    //}
}