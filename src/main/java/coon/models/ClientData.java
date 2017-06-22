package coon.models;


import coon.controllers.Client;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;


public class ClientData implements RowMapper<ClientData> {

    private int id;
    private String name;


    public ClientData(int id, String name) {
        this.id = id;
        this.name = name;
    }


    public ClientData() {}


    @Override
    public ClientData mapRow(ResultSet resultSet, int i) throws SQLException {
        return new ClientData(
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
