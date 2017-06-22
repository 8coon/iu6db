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
    private Integer[] flight;
    private Integer reverse = null;

    private String clientName;
    private int firstFlightId;
    private String firstFlightDate;
    private String airlineCode;
    private String airlineName;
    private String fromAirportCode;
    private String fromAirportName;
    private String toAirportCode;
    private String toAirportName;


    @JsonCreator
    public OrderData(
            @JsonProperty("id") int id,
            @JsonProperty("client") int client,
            @JsonProperty("date") String date,
            @JsonProperty("flight") Integer[] flight,
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
        OrderData order = new OrderData(
                resultSet.getInt("id"),
                resultSet.getInt("client"),
                LocalDateTime.ofInstant(
                        resultSet.getTimestamp("date").toInstant(),
                        ZoneOffset.ofHours(0)
                ).format(
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
                ),
                (Integer[]) resultSet.getArray("flight").getArray(),
                (Integer) resultSet.getObject("reverse")
        );

        order.setClientName(resultSet.getString("clientName"));
        order.setFirstFlightId(resultSet.getInt("flightId"));
        order.setFirstFlightDate(resultSet.getString("flightStart"));
        order.setAirlineCode(resultSet.getString("airlineCode"));
        order.setAirlineName(resultSet.getString("airlineName"));
        order.setFromAirportCode(resultSet.getString("fromAirportCode"));
        order.setFromAirportName(resultSet.getString("fromAirportName"));
        order.setToAirportCode(resultSet.getString("toAirportCode"));
        order.setToAirportName(resultSet.getString("toAirportName"));

        return order;
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

    public Integer[] getFlight() {
        return flight;
    }

    public void setFlight(Integer[] flight) {
        this.flight = flight;
    }

    public Integer getReverse() {
        return reverse;
    }

    public void setReverse(Integer reverse) {
        this.reverse = reverse;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public int getFirstFlightId() {
        return firstFlightId;
    }

    public void setFirstFlightId(int firstFlightId) {
        this.firstFlightId = firstFlightId;
    }

    public String getFirstFlightDate() {
        return firstFlightDate;
    }

    public void setFirstFlightDate(String firstFlightDate) {
        this.firstFlightDate = firstFlightDate;
    }

    public String getAirlineCode() {
        return airlineCode;
    }

    public void setAirlineCode(String airlineCode) {
        this.airlineCode = airlineCode;
    }

    public String getAirlineName() {
        return airlineName;
    }

    public void setAirlineName(String airlineName) {
        this.airlineName = airlineName;
    }

    public String getFromAirportCode() {
        return fromAirportCode;
    }

    public void setFromAirportCode(String fromAirportCode) {
        this.fromAirportCode = fromAirportCode;
    }

    public String getFromAirportName() {
        return fromAirportName;
    }

    public void setFromAirportName(String fromAirportName) {
        this.fromAirportName = fromAirportName;
    }

    public String getToAirportCode() {
        return toAirportCode;
    }

    public void setToAirportCode(String toAirportCode) {
        this.toAirportCode = toAirportCode;
    }

    public String getToAirportName() {
        return toAirportName;
    }

    public void setToAirportName(String toAirportName) {
        this.toAirportName = toAirportName;
    }

}
