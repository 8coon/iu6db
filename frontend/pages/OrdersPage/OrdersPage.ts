'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {ClientData, OrderData} from "../../models/AllModels";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'OrdersView', controller: 'OrdersController' })
export class OrdersPage {

    @(<any> JSWorks.ComponentCollectionProperty())
    public orders: OrderData[] = [];

}