include "gateway.iol"
include "console.iol"
include "../config.iol"



inputPort Gateway {
    Location: Gateway_Location
    Protocol: http { .statusCode => .statusCode}
    Interfaces: GatewayInterface
    Aggregates:
}


init {
    println@Console("Gateway Service Started)();
    install { Aborted => nullProcess}
}

main {
    [api( request )( response ) {

    }]
}