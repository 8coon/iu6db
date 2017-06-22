package coon.models;


import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class FlightData implements RowMapper<FlightData> {

    private int id;
    private String fromAirportCode;
    private String toAirportCode;
    private String airlineName;
    private String airlineCode;
    private String fromCityName;
    private String toCityName;
    private String dateStart;
    private String dateEnd;

    public String orderDate = null;
    public Integer order = null;

    public List<FlightData> flights = new ArrayList<>();
    private List<String> prefixes = new ArrayList<>();


    public FlightData() {
        this.prefixes.add("");
    }

    public FlightData(String[] prefixes) {
        Collections.addAll(this.prefixes, prefixes);
    }


    private FlightData map(ResultSet resultSet, String prefix) throws SQLException {
        FlightData fd = new FlightData();

        fd.setId(resultSet.getInt(prefix + "id"));
        fd.setFromAirportCode(resultSet.getString(prefix + "fromAirportCode"));
        fd.setToAirportCode(resultSet.getString(prefix + "toAirportCode"));
        fd.setAirlineName(resultSet.getString(prefix + "airlineName"));
        fd.setAirlineCode(resultSet.getString(prefix + "airlineCode"));

        try {
            fd.setFromCityName(resultSet.getString(prefix + "fromCityName"));
            fd.setToCityName(resultSet.getString(prefix + "toCityName"));
        } catch (SQLException e) {
            fd.setFromCityName(resultSet.getString(prefix + "fromAirportName"));
            fd.setToCityName(resultSet.getString(prefix + "toAirportName"));
        }

        fd.setDateStart(LocalDateTime.ofInstant(
                resultSet.getTimestamp(prefix + "dateStart").toInstant(),
                ZoneOffset.ofHours(0)
        ).format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
        ));

        fd.setDateEnd(LocalDateTime.ofInstant(
                resultSet.getTimestamp(prefix + "dateEnd").toInstant(),
                ZoneOffset.ofHours(0)
        ).format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
        ));

        try {
            fd.orderDate = LocalDateTime.ofInstant(
                    resultSet.getTimestamp(prefix + "orderDate").toInstant(),
                    ZoneOffset.ofHours(0)
            ).format(
                    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
            );

            fd.order = resultSet.getInt(prefix + "order");
        } catch (SQLException e) {
            fd.orderDate = null;
            fd.order = null;
        }

        return fd;
    }


    @Override
    public FlightData mapRow(ResultSet resultSet, int i) throws SQLException {
        if (this.prefixes.size() == 1) {
            return this.map(resultSet, "");
        }

        FlightData fd = new FlightData();

        for (String prefix: prefixes) {
            try {
                fd.flights.add(this.map(resultSet, prefix));
            } catch (NullPointerException e) {
                break;
            }
        }

        return fd;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFromAirportCode() {
        return fromAirportCode;
    }

    public void setFromAirportCode(String fromAirportCode) {
        this.fromAirportCode = fromAirportCode;
    }

    public String getToAirportCode() {
        return toAirportCode;
    }

    public void setToAirportCode(String toAirportCode) {
        this.toAirportCode = toAirportCode;
    }

    public String getAirlineName() {
        return airlineName;
    }

    public void setAirlineName(String airlineName) {
        this.airlineName = airlineName;
    }

    public String getAirlineCode() {
        return airlineCode;
    }

    public void setAirlineCode(String airlineCode) {
        this.airlineCode = airlineCode;
    }

    public String getFromCityName() {
        return fromCityName;
    }

    public void setFromCityName(String fromCityName) {
        this.fromCityName = fromCityName;
    }

    public String getToCityName() {
        return toCityName;
    }

    public void setToCityName(String toCityName) {
        this.toCityName = toCityName;
    }

    public String getDateStart() {
        return dateStart;
    }

    public void setDateStart(String dateStart) {
        this.dateStart = dateStart;
    }

    public String getDateEnd() {
        return dateEnd;
    }

    public void setDateEnd(String dateEnd) {
        this.dateEnd = dateEnd;
    }

}
