import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class NewOrderController {

    public view: View;


    public onNavigate(args: object): void {
    }

}
