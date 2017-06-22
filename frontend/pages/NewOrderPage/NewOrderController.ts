import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";
import {SimpleVirtualDOM} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOM";
import {AllModels, ClientData, OrderData, CityData, FlightData} from "../../models/AllModels";
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

        const virtualDOM: SimpleVirtualDOM = JSWorks.applicationContext.serviceHolder
                .getServiceByName('SimpleVirtualDOM');


        const select: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#current-client');
        select.removeChildren();


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
            this.checkReady(select, fromSelect, toSelect, dateInputs[0], dateInputs[1]);
        });


        const toSelect: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('#to-city');
        toSelect.removeChildren();

        toSelect.removeEventListeners();
        toSelect.addEventListener('change', () => {
            this.checkReady(select, fromSelect, toSelect, dateInputs[0], dateInputs[1]);
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

        calendar.controller.onSelect = (calendar: CalendarComponent, date: Date) => {
            activeInput.rendered['value'] = date.toDateString();
            activeInput.rendered.dispatchEvent(new Event('change'));
            activeInput.setAttribute('value', date.toDateString());
            this.checkReady(select, fromSelect, toSelect, dateInputs[0], dateInputs[1]);
        };

        select.addEventListener('change', () => {
            this.checkReady(select, fromSelect, toSelect, dateInputs[0], dateInputs[1]);
        });
    }


    private checkReady(
        userSelect: SimpleVirtualDOMElement,
        fromCitySelect: SimpleVirtualDOMElement,
        toCitySelect: SimpleVirtualDOMElement,
        orderDateInput: SimpleVirtualDOMElement,
        flightDateInput: SimpleVirtualDOMElement
    ) {
        const value = (item: SimpleVirtualDOMElement): string => (<any> item.rendered).value;
        this.component.error = '';

        if (!(
            value(userSelect) !== 'Выберите клиента:' &&
            value(fromCitySelect) !== 'Выберите город:' &&
            value(toCitySelect) !== 'Выберите город:' &&
            value(orderDateInput) != '' &&
            value(flightDateInput) != ''
        )) {
            this.component.flights = [];
            return;
        }

        if (new Date(value(orderDateInput)) > new Date(value(flightDateInput))) {
            this.component.error = 'Нельзя бронировать билеты на рейс после его вылета! ' +
                'Укажите другое время путешествия.';
            return;
        }

        if (value(fromCitySelect) === value(toCitySelect)) {
            this.component.error = 'Город отправления и город прибытия должны совпадать!';
            return;
        }


        this.net.flights(
            this.net.idByDisplay(value(fromCitySelect)),
            this.net.idByDisplay(value(toCitySelect)),
            new Date(value(flightDateInput)).toISOString().replace(' ', 'T'),
        ).then((flights: FlightData[]) => {
            this.component.flights = flights;

            window.setTimeout(() => {
                const buttons: SimpleVirtualDOMElement[] = this.view.DOMRoot.querySelectorAll('.order-button');

                buttons.forEach((button: SimpleVirtualDOMElement) => {
                    button.removeEventListeners();
                    button.addEventListener('click', () => {
                        this.net.createOrder(
                            this.net.idByDisplay(value(userSelect)),
                            new Date(value(orderDateInput)),
                            parseInt(button.id.split('-')[1], 10),
                            []
                        ).then((success: boolean) => {
                            if (success) {
                                alert('Заказ успешно добавлен.');

                                JSWorks.applicationContext.router.navigate(
                                    JSWorks.applicationContext.routeHolder.getRoute('OrdersRoute'),
                                    {},
                                )
                            } else {
                                alert('Ошибка добалвения заказа.')
                            }
                        }).catch((err) => {
                            alert(`Ошибка: ${err}`);
                        });
                    });
                });
            }, 10);
        });
    }

}
