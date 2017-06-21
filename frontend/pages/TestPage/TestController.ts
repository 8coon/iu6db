import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class TestController {

    public view: View;


    public onNavigate(args: object): void {
        alert("It Works!");
    }

}
