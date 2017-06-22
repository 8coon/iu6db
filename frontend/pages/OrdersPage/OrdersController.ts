import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";
import {SimpleVirtualDOM} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOM";
import {AllModels, ClientData, OrderData} from "../../models/AllModels";
import {OrdersPage} from "./OrdersPage";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class OrdersController {

    public view: View;
    public component: OrdersPage;
    public net: AllModels;


    public onNavigate(args: object): void {
        this.net = <AllModels> JSWorks.applicationContext.modelHolder.getModel('AllModels');

        const virtualDOM: SimpleVirtualDOM = JSWorks.applicationContext.serviceHolder
                .getServiceByName('SimpleVirtualDOM');

        const select: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#current-client');
        select.removeChildren();

        select.removeEventListeners();
        select.addEventListener('change', () => {
            const clientDisplay: string = (<HTMLSelectElement> select.rendered).value;

            this.net.clientOrders(this.net.idByDisplay(clientDisplay)).then((orders: OrderData[]) => {
                this.component.orders = orders;
            });
        });


        this.net.clients().then((clients: ClientData[]) => {
            const option: SimpleVirtualDOMElement = virtualDOM.createElement('OPTION');
            option.appendChild(virtualDOM.createTextElement('Выберите клиента:'));
            select.appendChild(option);

            clients.forEach((client: ClientData) => {
                const option: SimpleVirtualDOMElement = virtualDOM.createElement('OPTION');
                option.appendChild(virtualDOM.createTextElement(client.displayName));
                select.appendChild(option);
            });
        });
    }

}
