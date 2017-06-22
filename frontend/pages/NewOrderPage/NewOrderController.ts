import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";
import {SimpleVirtualDOM} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOM";
import {AllModels, ClientData, OrderData, CityData} from "../../models/AllModels";
import {NewOrderPage} from "./NewOrderPage";
import {AbstractController} from "../AbstractController";
import {CalendarComponent} from "../../components/CalendarComponent/CalendarComponent";
import {ComponentElement} from "jsworks/dist/dts/CustomElements/ViewElements/ComponentElement";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class NewOrderController extends AbstractController {

    public component: NewOrderPage;


    public onNavigate(args: object): void {
        super.onNavigate(args);

        const calendar: CalendarComponent = <CalendarComponent> (<ComponentElement>
                this.view.DOMRoot.querySelector('.select-date')).component;
        calendar.controller.updateCalendar();
        calendar.controller.hide();

        const dateInputs: SimpleVirtualDOMElement[] = this.view.DOMRoot.querySelectorAll('.show-calendar');
        let activeInput: SimpleVirtualDOMElement;

        dateInputs.forEach((dateInput: SimpleVirtualDOMElement) => {
            dateInput.removeEventListeners('focus');
            dateInput.addEventListener('focus', () => {
                const boundingRect = (<HTMLElement> dateInput.rendered).getBoundingClientRect();

                calendar.controller.setDate((<any> dateInput.rendered).value);
                calendar.controller.show(boundingRect.left, boundingRect.top);
                activeInput = dateInput;
            });

        });

        calendar.controller.onSelect = (calendar: CalendarComponent, date: Date) => {
            activeInput.rendered['value'] = date.toDateString();
            activeInput.rendered.dispatchEvent(new Event('change'));
            activeInput.setAttribute('value', date.toDateString());
        };

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


        const fromSelect: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#from-city');
        fromSelect.removeChildren();

        fromSelect.removeEventListeners();
        fromSelect.addEventListener('change', () => {
            // ToDo: validate
        });


        const toSelect: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#to-city');
        toSelect.removeChildren();

        toSelect.removeEventListeners();
        toSelect.addEventListener('change', () => {
            // ToDo: validate
        });


        this.net.cities().then((cities: CityData[]) => {
            const option: SimpleVirtualDOMElement = virtualDOM.createElement('OPTION');
            option.appendChild(virtualDOM.createTextElement('Выберите город:'));
            fromSelect.appendChild(option);
            toSelect.appendChild(option.cloneNode());

            cities.forEach((city: CityData) => {
                const option: SimpleVirtualDOMElement = virtualDOM.createElement('OPTION');
                option.appendChild(virtualDOM.createTextElement(city.displayName));
                fromSelect.appendChild(option);
                toSelect.appendChild(option.cloneNode());
            });
        });

    }

}
