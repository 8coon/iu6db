'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {ClientData, OrderData, DetailsData} from "../../models/AllModels";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'DetailsView', controller: 'DetailsController' })
export class DetailsPage {

    @(<any> JSWorks.ComponentCollectionProperty())
    public details: DetailsData[] = [];

}