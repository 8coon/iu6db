'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {ClientData, OrderData} from "../../models/AllModels";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'NewOrderView', controller: 'NewOrderController' })
export class NewOrderPage {

    @(<any> JSWorks.ComponentCollectionProperty())
    public orders: OrderData[] = [];

}