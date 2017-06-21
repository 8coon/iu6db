import {Route} from "jsworks/dist/dts/Router/Route";
import {TableComponent} from "./TableComponent";


export interface ITableForeignKey {
    route: Route | string;
    valueKey?: string;
}


export interface ITableColumn {
    name: string;
    title: string;
    width?: number;  // Relative from the width of the whole table

    foreignKey?: ITableForeignKey;
    order?: string;  // 'asc' or 'desc'
    filter?: string;

    // These default to false
    canOrder?: boolean;
    canFilter?: boolean;
    canEdit?: boolean;
    isTitle?: boolean;

    pixelWidth?: number;
    verticalTitle?: boolean;

    type?: string;  // 'button' or 'select' or nothing for a standard text type
    selectList?: string[];
    buttonText?: string;
    onButtonClick?: (table: TableComponent, data: object) => void;
}
