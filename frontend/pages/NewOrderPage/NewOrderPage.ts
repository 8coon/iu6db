'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {ClientData, OrderData, FlightData} from "../../models/AllModels";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'NewOrderView', controller: 'NewOrderController' })
export class NewOrderPage {

    @(<any> JSWorks.ComponentCollectionProperty())
    public flights: FlightData[] = [];

    @(<any> JSWorks.ComponentCollectionProperty())
    public reverseFlights: FlightData[] = [];

    @(<any> JSWorks.ComponentProperty())
    public error: string = '';

}