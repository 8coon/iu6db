package coon.controllers;


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


    @GetMapping("/list")
    public ResponseEntity<List<FlightData>> list(
            @RequestParam(name = "from", required = true) int fromCity,
            @RequestParam(name = "to", required = true) int toCity,
            @RequestParam(name = "connecting", defaultValue = "false", required = false) boolean connectingFlights
    ) {
        return new ResponseEntity<>(
                this.jdbc.query(
                        "SELECT * FROM flightsFromCityToCity WHERE fromCityId = ? AND toCityId = ?",
                        new FlightData(),
                        fromCity, toCity
                ),
                HttpStatus.OK
        );
    }

}
