package coon.json;


import coon.models.FlightData;

import java.util.ArrayList;
import java.util.List;


public class FlightsListResponse {

    private Object flights;
    private Object reverseFlights;


    public FlightsListResponse(Object flights, Object reverseFlights) {
        if (flights == null) {
            flights = new ArrayList<>();
        }

        if (reverseFlights == null) {
            reverseFlights = new ArrayList<>();
        }

        this.flights = flights;
        this.reverseFlights = reverseFlights;
    }


    public Object getFlights() {
        return flights;
    }

    public void setFlights(Object flights) {
        this.flights = flights;
    }

    public Object getReverseFlights() {
        return reverseFlights;
    }

    public void setReverseFlights(Object reverseFlights) {
        this.reverseFlights = reverseFlights;
    }

}
