package coon.models;


import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;


public class OrderData implements RowMapper<OrderData> {

    private int id;
    private int client;
    private String date;
    private int flight;
    private Integer reverse = null;


    @JsonCreator
    public OrderData(
            @JsonProperty("id") int id,
            @JsonProperty("client") int client,
            @JsonProperty("date") String date,
            @JsonProperty("flight") int flight,
            @JsonProperty("reverse") Integer reverse
    ) {
        this.id = id;
        this.client = client;
        this.date = date;
        this.flight = flight;
        this.reverse = reverse;
    }

    public OrderData() {}

    @Override
    public OrderData mapRow(ResultSet resultSet, int i) throws SQLException {
        return new OrderData(
                resultSet.getInt("id"),
                resultSet.getInt("client"),
                LocalDateTime.ofInstant(
                        resultSet.getTimestamp("date").toInstant(),
                        ZoneOffset.ofHours(0)
                ).format(
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
                ),
                resultSet.getInt("flight"),
                (Integer) resultSet.getObject("reverse")
        );
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getClient() {
        return client;
    }

    public void setClient(int client) {
        this.client = client;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getFlight() {
        return flight;
    }

    public void setFlight(int flight) {
        this.flight = flight;
    }

    public Integer getReverse() {
        return reverse;
    }

    public void setReverse(Integer reverse) {
        this.reverse = reverse;
    }

}
