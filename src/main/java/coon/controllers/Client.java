package coon.controllers;


import coon.json.Response;
import coon.models.ClientData;
import coon.models.OrderData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/client")
public class Client {

    private JdbcTemplate jdbc;

    @Autowired
    public Client(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }


    @PostMapping("/{id}/order/create")
    public ResponseEntity<Response> create(
            @RequestParam("id") int client,
            @RequestBody OrderData order
    ) {
        order.setClient(client);

        this.jdbc.update(
                "INSERT INTO Orders (client, date, flight) VALUES (?, ?, ?)",
                order.getClient(), order.getDate(), order.getFlight()
        );

        return new ResponseEntity<>(
                new Response("success"),
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

}
