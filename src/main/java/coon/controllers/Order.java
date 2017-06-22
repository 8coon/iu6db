package coon.controllers;


import coon.json.FlightsListResponse;
import coon.models.FlightData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/order")
public class Order {

    private JdbcTemplate jdbc;

    @Autowired
    public Order(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }


    @GetMapping("/{id}/details")
    public ResponseEntity<?> details(
            @PathVariable("id") int id
    ) {
        List<FlightData> flightList = this.jdbc.query(
                "SELECT * FROM orderDetails WHERE \"order\" = ?",
                new FlightData(),
                id
        );

        return new ResponseEntity<>(
                new Object() {
                    public String date = flightList.get(0).orderDate;
                    public List<FlightData> flights = flightList;
                },
                HttpStatus.OK
        );
    }

}
