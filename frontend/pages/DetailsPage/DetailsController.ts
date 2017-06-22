import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";
import {SimpleVirtualDOM} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOM";
import {AllModels, ClientData, OrderData, DetailsData} from "../../models/AllModels";
import {DetailsPage} from "./DetailsPage";
import {AbstractController} from "../AbstractController";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class DetailsController extends AbstractController {

    public component: DetailsPage;


    public onNavigate(args: object): void {
        super.onNavigate(args);
        const orderId: number = parseInt(args['id'] || args[':id'], 10);

        this.net.details(orderId).then((details: DetailsData) => {
            this.component.details = [details];
        });
    }

}
