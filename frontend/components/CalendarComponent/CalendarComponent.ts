import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {CalendarController} from "./CalendarController";


declare const JSWorks: JSWorksLib;


@JSWorks.Component({ view: 'CalendarView', controller: 'CalendarController' })
export class CalendarComponent {

    public controller: CalendarController;


    @(<any> JSWorks.ComponentProperty())
    public monthName: string = 'ЯНВАРЬ 1970';

    @(<any> JSWorks.ComponentProperty())
    public date: Date = new Date();

}