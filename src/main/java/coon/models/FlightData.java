package coon.models;


import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;


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


    public FlightData() {}


    @Override
    public FlightData mapRow(ResultSet resultSet, int i) throws SQLException {
        FlightData fd = new FlightData();

        fd.setId(resultSet.getInt("id"));
        fd.setFromAirportCode(resultSet.getString("fromAirportCode"));
        fd.setToAirportCode(resultSet.getString("toAirportCode"));
        fd.setAirlineName(resultSet.getString("airlineName"));
        fd.setAirlineCode(resultSet.getString("airlineCode"));
        fd.setFromCityName(resultSet.getString("fromCityName"));
        fd.setToCityName(resultSet.getString("toCityName"));

        fd.setDateStart(LocalDateTime.ofInstant(
                resultSet.getTimestamp("dateStart").toInstant(),
                ZoneOffset.ofHours(0)
        ).format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
        ));

        fd.setDateEnd(LocalDateTime.ofInstant(
                resultSet.getTimestamp("dateEnd").toInstant(),
                ZoneOffset.ofHours(0)
        ).format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")
        ));

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
