import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {View} from "jsworks/dist/dts/View/View";
import {SimpleVirtualDOMElement} from "jsworks/dist/dts/VirtualDOM/SimpleVirtualDOM/SimpleVirtualDOMElement";
import {CalendarComponent} from "./CalendarComponent";
import {TableComponent} from "../TableComponent/TableComponent";
import {ComponentElement} from "jsworks/dist/dts/CustomElements/ViewElements/ComponentElement";
import {ITableColumn} from "../TableComponent/ITable";


declare const JSWorks: JSWorksLib;


@JSWorks.Controller
export class CalendarController {

    public view: View;
    public component: CalendarComponent;

    public visible: boolean = false;

    public onSelect: (calendar: CalendarComponent, date: Date) => void;


    public onCreate(): void {
    }


    public static toRussianWeekday(americanWeekday: number): number {
        americanWeekday -= 1;

        if (americanWeekday < 0) {
            return 6;
        }

        return americanWeekday;
    }


    public setDate(date: Date): void {
        const months: string[] = [
            'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь',
            'Октябрь', 'Ноябрь', 'Декабрь',
        ];

        if (<any> date === '') {
            date = new Date();
        }

        date = new Date(date);
        this.component.monthName = `${months[date.getMonth()].toUpperCase()} ${date.getFullYear()}`;
        this.component.date = date;

        this.updateCalendar();
    }


    public updateCalendar(): void {
        const weekdayNames: string[] = [
            'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс',
        ];

        const table: TableComponent = (<ComponentElement>
                this.view.DOMRoot.querySelector('.calendar-table')).component;
        table.paginator = false;
        table.toolbox = false;
        table.selectable = false;

        table.onCellClick = (table: TableComponent, row, column, data) => {
            if (!this.visible) {
                return;
            }

            const date: Date = new Date(
                this.component.date.getFullYear(),
                this.component.date.getMonth(),
                data[weekdayNames[column]]
            );

            this.setDate(date);
            this.hide();

            if (this.onSelect) {
                this.onSelect(this.component, date);
            }
        };

        const back: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('.calendar-month-left');
        back.removeEventListeners('click');
        back.addEventListener('click', () => {
            let newMonth: number = this.component.date.getMonth() - 1;
            let newYear: number = this.component.date.getFullYear();

            if (newMonth < 0) {
                newMonth = 11;
                newYear -= 1;
            }

            this.setDate(new Date(newYear, newMonth, 1));
        });

        const forward: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('.calendar-month-right');
        forward.removeEventListeners('click');
        forward.addEventListener('click', () => {
            let newMonth: number = this.component.date.getMonth() + 1;
            let newYear: number = this.component.date.getFullYear();

            if (newMonth > 11) {
                newMonth = 0;
                newYear += 1;
            }

            this.setDate(new Date(newYear, newMonth, 1));
        });



        const weeks: object[] = [];
        let weekdays: object = {};
        let weekdaysCount: number = 0;
        const month: number = this.component.date.getMonth();
        const startDate: Date = new Date(this.component.date.getFullYear(), month, 1);

        for (let date: Date = startDate; date.getMonth() === month; date.setDate(date.getDate() + 1)) {
            const weekday: number = CalendarController.toRussianWeekday(date.getDay());

            if (weekdaysCount === 0 && weekday > 0) {
                for (let i = 0; i < weekday; i++) {
                    weekdays[weekdayNames[weekday]] = '';
                    weekdaysCount++;
                }
            }

            weekdays[weekdayNames[weekday]] = `${date.getDate()}`;
            weekdaysCount++;

            const daysInMonth: number = new Date(date.getFullYear(), date.getMonth(), 0).getDate();

            if (weekdaysCount > 6) {
                weeks.push(weekdays);
                weekdays = {};
                weekdaysCount = 0;
            }
        }

        if (weekdaysCount !== 0) {
            weeks.push(weekdays);
        }

        (<any> table.data).setValues(weeks);
        (<any> table.columns).setValues(weekdayNames.map((dayName: string): ITableColumn => {
            return {
                name: dayName,
                title: dayName,
            }
        }));
    }


    public show(left: number, top: number): void {
        const element: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('.calendar-container');
        this.visible = true;

        element.setStyleAttribute('left', `${Math.round(left)}px`);
        element.setStyleAttribute('top', `${Math.round(top)}px`);
        element.toggleClass('hidden', false);
    }


    public hide(): void {
        const element: SimpleVirtualDOMElement = this.view.DOMRoot.querySelector('.calendar-container');
        element.toggleClass('hidden', true);
        this.visible = false;
    }


    public onDOMInsert(): void {
        this.setDate(new Date());
    }

}
