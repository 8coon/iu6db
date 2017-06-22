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
    public firstFlightDate: string;
    public airlineCode: string;
    public airlineName: string;
    public fromAirportCode: string;
    public fromAirportName: string;
    public toAirportCode: string;
    public toAirportName: string;

    public get firstFlightId(): number {
        return this.flight[0];
    }

    public set firstFlightId(value: number) {
    }

    public get formattedFlightStart(): string {
        return this.firstFlightDate;
    }

    public get formattedFlightEnd(): string {
        return ''; //this.flightEnd;
    }

    public get flightCode(): string {
        return `${this.airlineCode}-${this.firstFlightId}`;
    }

}


export class ClientData extends BackendData {
    public id: number;
    public name: string;

    public get displayName(): string {
        return `${this.id} - ${this.name}`;
    }
}


export class CityData extends BackendData {
    public id: number;
    public name: string;

    public get displayName(): string {
        return `${this.id} - ${this.name}`;
    }
}


export class FlightData extends BackendData {
    public id: number;
    public fromAirportCode: string;
    public toAirportCode: string;
    public airlineName: string;
    public airlineCode: string;
    public fromCityName: string;
    public toCityName: string;
    public dateStart: string;
    public dateEnd: string;
    public flights: FlightData[] = [];

    public get formattedDateStart(): string {
        return this.dateStart;
    }

    public get formattedDateEnd(): string {
        return this.dateEnd;
    }

    public get flightDisplayName(): string {
        return this.airlineName;
    }

    public get flightDisplayCode(): string {
        return `${this.airlineCode}-${this.id}`;
    }

    public get children(): FlightData[] {
        return this.flights;
    }

    public set children(flights: FlightData[]) {}
}


export interface FlightsData {
    flights: FlightData[];
    reverseFlights: FlightData[];
}


export class DetailsData extends BackendData {
    public date: string;
    public order: number;
    public flights: FlightData[];

    public get formattedDate(): string {
        return this.date;
    }

    public set formattedDate(value: string) {
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
                { 'Content-Type': 'application/json' }
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
                { 'Content-Type': 'application/json' }
            ).then((orders: any[]) => {
                resolve(orders.map(order => <ClientData> BackendData.Apply(new ClientData(), order)));
            }).catch((err) => {
                reject(err);
            });
        });
    }


    public cities(): Promise<CityData[]> {
        return new Promise<CityData[]>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                `${JSWorks.config['backendURL']}/api/client/cities`,
                JSWorks.HTTPMethod.GET,
                null,
                { 'Content-Type': 'application/json' }
            ).then((orders: any[]) => {
                resolve(orders.map(order => <CityData> BackendData.Apply(new CityData(), order)));
            }).catch((err) => {
                reject(err);
            });
        });
    }


    public flights(from: number, to: number, date: string, reverse?: string): Promise<FlightsData> {
        let url: string = `${JSWorks.config['backendURL']}/api/flights/list/?from=${from}&to=${to}&date=${date}`;

        if (reverse !== undefined) {
            url += `&reverse=${reverse}`;
        }

        url += '&connecting=true';

        return new Promise<FlightsData>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                url,
                JSWorks.HTTPMethod.GET,
                null,
                { 'Content-Type': 'application/json' }
            ).then((flights: FlightsData) => {
                const mapFlights = (flights: FlightData[]): FlightData[] => {
                    return flights.map((flight: FlightData) => {
                        const newFlight: FlightData = <FlightData> BackendData.Apply(new FlightData(), flight);
                        newFlight.flights = mapFlights(newFlight.flights);

                        return newFlight;
                    });
                };

                resolve({
                    flights: mapFlights(flights.flights),
                    reverseFlights: mapFlights(flights.reverseFlights),
                });
            }).catch((err) => {
                reject(err);
            });
        });
    }


    public createOrder(
        client: number,
        date: Date,
        reverseDate: Date,
        flight: number,
        children: number[],
        reverseFlight: number,
        reverseChildren: number[]
    ): Promise<boolean> {
        let reverseDateString: string;
        let reverseFlightArray: number[];

        if (reverseDate !== undefined && reverseFlight !== undefined) {
            reverseDateString = reverseDate.toISOString().replace(' ', 'T');
            reverseFlightArray = reverseChildren;
        }

        return new Promise<boolean>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                `${JSWorks.config['backendURL']}/api/client/${client}/orders/new`,
                JSWorks.HTTPMethod.POST,
                JSON.stringify({
                    date: date.toISOString().replace(' ', 'T'), flight: children,
                    reverseDate: reverseDateString, reverseChildren: reverseFlightArray
                }),
                { 'Content-Type': 'application/json' }
            ).then(() => {
                resolve(true);
            }).catch((err) => {
                reject(err);
            });
        });
    }


    public details(id: number): Promise<DetailsData> {
        return new Promise<DetailsData>((resolve, reject) => {
            this.jsonParser.parseURLAsync(
                `${JSWorks.config['backendURL']}/api/order/${id}/details`,
                JSWorks.HTTPMethod.GET,
                null,
                { 'Content-Type': 'application/json' }
            ).then((data: DetailsData) => {
                data = <DetailsData> BackendData.Apply(new DetailsData(), data);
                data.flights = data.flights.map(
                    flight => <FlightData> BackendData.Apply(new FlightData(), flight)
                );

                resolve(data);
            }).catch((err) => {
                reject(err);
            });
        });
    }

}
