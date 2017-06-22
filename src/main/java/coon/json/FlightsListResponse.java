package coon.json;


import coon.models.FlightData;

import java.util.ArrayList;
import java.util.List;


public class FlightsListResponse {

    private List<FlightData> flights;
    private List<FlightData> reverseFlights;


    public FlightsListResponse(List<FlightData> flights, List<FlightData> reverseFlights) {
        if (flights == null) {
            flights = new ArrayList<>();
        }

        if (reverseFlights == null) {
            reverseFlights = new ArrayList<>();
        }

        this.flights = flights;
        this.reverseFlights = reverseFlights;
    }


    public List<FlightData> getFlights() {
        return flights;
    }

    public void setFlights(List<FlightData> flights) {
        this.flights = flights;
    }

    public List<FlightData> getReverseFlights() {
        return reverseFlights;
    }

    public void setReverseFlights(List<FlightData> reverseFlights) {
        this.reverseFlights = reverseFlights;
    }

}
