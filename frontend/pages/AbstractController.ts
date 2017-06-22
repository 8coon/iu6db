import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {AllModels} from "../models/AllModels";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class AbstractController {

    public view: View;
    public net: AllModels;


    public onNavigate(args: object): void {
        this.net = <AllModels> JSWorks.applicationContext.modelHolder.getModel('AllModels');

        const newOrder: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#new-order');
        newOrder.removeEventListeners();

        newOrder.addEventListener('click', () => {
            JSWorks.applicationContext.router.navigate(
                JSWorks.applicationContext.routeHolder.getRoute('NewOrderRoute'),
                {},
            )
        });

        const h1: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('h1');
        h1.removeEventListeners();

        h1.addEventListener('click', () => {
            JSWorks.applicationContext.router.navigate(
                JSWorks.applicationContext.routeHolder.getRoute('OrdersRoute'),
                {},
            )
        });
    }

}
