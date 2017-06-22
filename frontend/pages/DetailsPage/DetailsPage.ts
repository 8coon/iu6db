'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {ClientData, OrderData} from "../../models/AllModels";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'DetailsView', controller: 'DetailsController' })
export class DetailsPage {

    @(<any> JSWorks.ComponentCollectionProperty())
    public order: OrderData[] = [];

}