'use strict';
import {JSWorksLib} from "jsworks/dist/dts/jsworks";


declare const JSWorks: JSWorksLib;


@JSWorks.Page({ view: 'TestView', controller: 'TestController' })
export class TestPage {

    @(<any> JSWorks.ComponentProperty())
    public dummy: string = '';

}