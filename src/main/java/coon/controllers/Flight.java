package coon.controllers;


import coon.json.FlightsListResponse;
import coon.models.FlightData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@RequestMapping("/api/flights")
public class Flight {

    private JdbcTemplate jdbc;

    @Autowired
    public Flight(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }


    private Object flightsQuery(int fromCity, int toCity, String date, boolean connecting) {
        if (connecting) {
            return this.jdbc.query(
                    "SELECT * FROM connectingFlights(?, ?, ?::TIMESTAMPTZ)",
                    new FlightData(new String[] {"F1_", "F2_", "F3_"}),
                    fromCity, toCity, date
            );
        } else {
            return this.jdbc.query(
                    "SELECT * FROM flightsFromCityToCity WHERE " +
                            "fromCityId = ? AND toCityId = ? AND " +
                            "date_trunc('day', dateStart) = date_trunc('day', ?::TIMESTAMPTZ)",
                    new FlightData(),
                    fromCity, toCity, date
            );
        }
    }

    @GetMapping("/list")
    public ResponseEntity<?> list(
            @RequestParam(name = "from", required = true) int fromCity,
            @RequestParam(name = "to", required = true) int toCity,
            @RequestParam(name = "date", required = true) String date,
            @RequestParam(name = "reverse", defaultValue = "", required = false) String reverse,
            @RequestParam(name = "connecting", defaultValue = "false", required = false) boolean connectingFlights
    ) {
        FlightsListResponse flights = new FlightsListResponse(
                this.flightsQuery(fromCity, toCity, date, connectingFlights),
                null
        );

        if (!reverse.equals("")) {
            flights.setReverseFlights(
                    this.flightsQuery(toCity, fromCity, reverse, connectingFlights)
            );
        }

        return new ResponseEntity<>(
                flights,
                HttpStatus.OK
        );
    }

}
