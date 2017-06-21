package coon.controllers;


import coon.json.Response;
import coon.models.OrderData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/order")
public class Order {

    private JdbcTemplate jdbc;

    @Autowired
    public Order(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }


    @PostMapping("/create")
    public ResponseEntity<Response> create(
            @RequestBody OrderData order
    ) {
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
    public ResponseEntity<?> orders(
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

}
