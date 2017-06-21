-- noinspection SqlNoDataSourceInspectionForFile


DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Users;


CREATE TABLE IF NOT EXISTS Users (
  id SERIAL PRIMARY KEY,
  firstName TEXT,
  lastName TEXT,
  midName TEXT,
  document INT
);


CREATE TABLE IF NOT EXISTS Cities (
  id SERIAL PRIMARY KEY,
  name TEXT,
  country TEXT
);


CREATE TABLE IF NOT EXISTS Orders (
  id SERIAL PRIMARY KEY,
  client INT REFERENCES Users,
  dateOrdered TIMESTAMPTZ,
  dateFlying TIMESTAMPTZ,
  cityFrom INT REFERENCES Cities,
  cityTo INT REFERENCES Cities
);

