'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'NewOrderView', controller: 'NewOrderController' })
export class NewOrderPage {

    @(<any> JSWorks.ComponentProperty())
    public dummy: string = '';

}