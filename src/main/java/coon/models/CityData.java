package coon.models;


import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;


public class CityData implements RowMapper<CityData> {

    private int id;
    private String name;


    public CityData(int id, String name) {
        this.id = id;
        this.name = name;
    }


    public CityData() {}


    @Override
    public CityData mapRow(ResultSet resultSet, int i) throws SQLException {
        return new CityData(
                resultSet.getInt("id"),
                resultSet.getString("name")
        );
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
