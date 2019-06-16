include "../Calculator/calculator.iol"
include "../sla/sla.iol"

interface GatewayInterface {
    RequestResponse:
        api(CalculatorRequestType)(SLAResponseType)
}