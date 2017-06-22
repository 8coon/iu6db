import {JSWorksLib} from "jsworks/dist/dts/jsworks";
import {IModel} from "jsworks/dist/dts/Model/IModel";
import {JSONParserService} from "jsworks/dist/dts/Parser/JSON/JSONParserService";


declare const JSWorks: JSWorksLib;


export class BackendData {
    public static Apply(source: BackendData, data): BackendData {
        Object.keys(data).forEach(key => source[key] = data[key]);
        return source;
    }
}


export class OrderData extends BackendData {
    public id: number;
    public client: number;
    public date: string;
    public flight: number[];
    public reverse: number;

    public clientName: string;
    public flightId: number;
    public flightStart: string;
    public airlineCode: string;
    public airlineName: string;
    public fromAirportCode: string;
    public fromAirportName: string;
    public toAirportCode: string;
    public toAirportName: string;

    public get formattedFlightStart(): string {
        return this.flightStart;
    }

    public get flightCode(): string {
        return `${this.airlineCode}-${this.flightId}`;
    }

}


export class ClientData extends BackendData {
    public id: number;
    public name: string;

    public get displayName(): string {
        return `${this.id} - ${this.name}`;
    }
}


@JSWorks.Model
export class AllModels implements IModel {

    public jsonParser: JSONParserService;


    public idByDisplay(display: string): number {
        return parseInt(String(display).split('-')[0].trim(), 10);
    }


    public clientOrders(clientId: number): Promise<OrderData[]> {
        return new Promise<OrderData[]>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                `${JSWorks.config['backendURL']}/api/client/${clientId}/orders`,
                JSWorks.HTTPMethod.GET,
                null,
                { 'Content-Type': 'application/jsonParser' }
            ).then((orders: any[]) => {
                resolve(orders.map(order => <OrderData> BackendData.Apply(new OrderData(), order)));
            }).catch((err) => {
                reject(err);
            });
        });
    }


    public clients(): Promise<ClientData[]> {
        return new Promise<ClientData[]>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                `${JSWorks.config['backendURL']}/api/client/list`,
                JSWorks.HTTPMethod.GET,
                null,
                { 'Content-Type': 'application/jsonParser' }
            ).then((orders: any[]) => {
                resolve(orders.map(order => <ClientData> BackendData.Apply(new ClientData(), order)));
            }).catch((err) => {
                reject(err);
            });
        });
    }

}
