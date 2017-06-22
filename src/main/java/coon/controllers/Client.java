package coon.controllers;


import coon.json.Response;
import coon.models.CityData;
import coon.models.ClientData;
import coon.models.OrderData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;


@RestController
@Transactional(propagation = Propagation.REQUIRES_NEW)
@RequestMapping("/api/client")
public class Client {

    private JdbcTemplate jdbc;

    @Autowired
    public Client(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }


    @PostMapping("/{id}/orders/new")
    public ResponseEntity<Response> create(
            @PathVariable("id") int client,
            @RequestBody OrderData order
    ) {
        Integer reverseId = null;

        if (order.reverseChildren != null) {
            ResponseEntity<Response> response = this.create(client, new OrderData(
                    0,
                    client,
                    order.reverseDate,
                    order.reverseChildren,
                    null,
                    null,
                    null
            ));

            reverseId = response.getBody().id;
        }

        int id = this.jdbc.queryForObject(
                "INSERT INTO Orders (client, date, reverse) VALUES (?, ?::TIMESTAMP, ?) RETURNING id",
                Integer.class,
                client, order.getDate(), reverseId
        );


        for (Integer flight: order.getFlight()) {
            this.jdbc.update(
                    "INSERT INTO OrderFlights (\"order\", flight) VALUES (?, ?)",
                        id, flight
            );
        }

        return new ResponseEntity<>(
                new Response("success", id),
                HttpStatus.OK
        );
    }


    @GetMapping("/{id}/orders")
    public ResponseEntity<List<OrderData>> orders(
            @PathVariable("id") int id
    ) {
        return new ResponseEntity<>(
                this.jdbc.query(
                        "SELECT * FROM clientOrders WHERE client = ?",
                        new OrderData(),
                        id
                ),
                HttpStatus.OK
        );
    }


    @GetMapping("/list")
    public ResponseEntity<List<ClientData>> list() {
        return new ResponseEntity<>(
                this.jdbc.query(
                        "SELECT * FROM clients",
                        new ClientData()
                ),
                HttpStatus.OK
        );
    }


    @GetMapping("/cities")
    public ResponseEntity<List<CityData>> cities() {
        return new ResponseEntity<>(
                this.jdbc.query(
                        "SELECT id, (name || ', '::TEXT || country) AS name FROM Cities",
                        new CityData()
                ),
                HttpStatus.OK
        );
    }

}
