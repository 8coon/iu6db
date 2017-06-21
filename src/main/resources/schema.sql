-- noinspection SqlNoDataSourceInspectionForFile

DROP VIEW IF EXISTS flightsFromCity;
DROP VIEW IF EXISTS clientOrders;
DROP VIEW IF EXISTS flightsFromCityToCity;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Airports;
DROP TABLE IF EXISTS Airlines;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Users;


CREATE TABLE IF NOT EXISTS Users (
  id SERIAL PRIMARY KEY,
  lastName TEXT,
  firstName TEXT,
  midName TEXT,
  document INT
);


CREATE TABLE IF NOT EXISTS Cities (
  id SERIAL PRIMARY KEY,
  name TEXT,
  country TEXT
);


CREATE TABLE IF NOT EXISTS Airlines (
  id SERIAL PRIMARY KEY,
  name TEXT,
  code TEXT
);


CREATE TABLE IF NOT EXISTS Airports (
  id SERIAL PRIMARY KEY,
  city INT REFERENCES Cities,
  name TEXT,
  code TEXT
);


CREATE TABLE IF NOT EXISTS Flights (
  id SERIAL PRIMARY KEY,
  fromAirport INT REFERENCES Airports,
  toAirport INT REFERENCES Airports,
  dateStart TIMESTAMP,
  dateEnd TIMESTAMP CHECK (dateEnd > dateStart),
  airline INT REFERENCES Airlines
);


CREATE TABLE IF NOT EXISTS Orders (
  id SERIAL PRIMARY KEY,
  client INT REFERENCES Users,
  date TIMESTAMP,
  flight INT[],
  reverse INT REFERENCES Orders DEFAULT NULL
);



CREATE OR REPLACE FUNCTION generateCities() RETURNS VOID AS 'BEGIN
  INSERT INTO Cities (country, name) VALUES
    (''USA'', ''Atlanta''),
    (''China'', ''Beijing''),
    (''UAE'', ''Dubai''),
    (''USA'', ''Los Angeles''),
    (''Japan'', ''Tokyo''),
    (''USA'', ''Chicago''),
    (''UK'', ''London''),
    (''China'', ''Hong Kong''),
    (''China'', ''Shanghai''),
    (''France'', ''Paris''),
    (''USA'', ''Dallas''),
    (''Netherlands'', ''Amsterdam''),
    (''Germany'', ''Frankfurt''),
    (''Turkey'', ''Istanbul''),
    (''China'', ''Guangzhou''),
    (''USA'', ''New York''),
    (''Singapore'', ''Singapore''),
    (''USA'', ''Denver''),
    (''Republic of Korea'', ''Seoul''),
    (''Thailand'', ''Bangkok''),
    (''Russia'', ''Moscow''),
    (''Russia'', ''St. Petersburg'');
END;' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generateAirports() RETURNS VOID AS 'BEGIN
  INSERT INTO Airports (name, code, city) VALUES
    (''Hartsfield–Jackson Atlanta International Airport'', ''ATL'', (SELECT id FROM Cities WHERE name = ''Atlanta'')),
    (''Beijing Capital International Airport'', ''PEK'', (SELECT id FROM Cities WHERE name = ''Beijing'')),
    (''Dubai International Airport'', ''DXB'', (SELECT id FROM Cities WHERE name = ''Dubai'')),
    (''Los Angeles International Airport'', ''LAX'', (SELECT id FROM Cities WHERE name = ''Los Angeles'')),
    (''Tokyo Haneda Airport'', ''HND'', (SELECT id FROM Cities WHERE name = ''Tokyo'')),
    (''O’Hare International Airport'', ''ORD'', (SELECT id FROM Cities WHERE name = ''Chicago'')),
    (''London Heathrow'', ''LHR'', (SELECT id FROM Cities WHERE name = ''London'')),
    (''Hong Kong International Airport'', ''HKG'', (SELECT id FROM Cities WHERE name = ''Hong Kong'')),
    (''Shanghai Pudong International Airport'', ''PVG'', (SELECT id FROM Cities WHERE name = ''Shanghai'')),
    (''Paris Charles de Gaulle Airport'', ''CDG'', (SELECT id FROM Cities WHERE name = ''Paris'')),
    (''Dallas/Fort Worth International Airport'', ''DFW'', (SELECT id FROM Cities WHERE name = ''Dallas'')),
    (''Amsterdam Airport Schiphol'', ''AMS'', (SELECT id FROM Cities WHERE name = ''Amsterdam'')),
    (''Frankfurt Airport'', ''FRA'', (SELECT id FROM Cities WHERE name = ''Frankfurt'')),
    (''Istanbul Atatürk Airport'', ''IST'', (SELECT id FROM Cities WHERE name = ''Istanbul'')),
    (''Guangzhou Baiyun International Airport'', ''CAN'', (SELECT id FROM Cities WHERE name = ''Guangzhou'')),
    (''John F. Kennedy International Airport'', ''JFK'', (SELECT id FROM Cities WHERE name = ''New York'')),
    (''Singapore Changi Airport'', ''SIN'', (SELECT id FROM Cities WHERE name = ''Singapore'')),
    (''Denver International Airport'', ''DEN'', (SELECT id FROM Cities WHERE name = ''Denver'')),
    (''Seoul Incheon International Airport'', ''ICN'', (SELECT id FROM Cities WHERE name = ''Seoul'')),
    (''Suvarnabhumi Airport'', ''BKK'', (SELECT id FROM Cities WHERE name = ''Bangkok'')),
    (''Domodedovo International Airport'', ''DME'', (SELECT id FROM Cities WHERE name = ''Moscow'')),
    (''Sheremetyevo International Airport'', ''SVO'', (SELECT id FROM Cities WHERE name = ''Moscow'')),
    (''Vnukovo International Airport'', ''VKO'', (SELECT id FROM Cities WHERE name = ''Moscow'')),
    (''Zhukovsky International Airport'', ''ZIA'', (SELECT id FROM Cities WHERE name = ''Moscow''));
END; ' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generateAirlines() RETURNS VOID AS 'BEGIN
  INSERT INTO Airlines (name, code) VALUES
    (''Air China'', ''CA''),
    (''Cubana de Aviación'', ''CU''),
    (''Scandinavian Airlines'', ''SK''),
    (''Finnair'', ''AY''),
    (''Air France'', ''AF''),
    (''Lufthansa'', ''LH''),
    (''Alitalia'', ''AZ''),
    (''Japan Airlines'', ''JA''),
    (''Malaysia Airlines'', ''MH''),
    (''Aeroméxico'', ''AM''),
    (''Singapore Airlines'', ''SQ''),
    (''British Airways'', ''BA''),
    (''Aeroflot'', ''SU''),
    (''American Airlines'', ''AA''),
    (''Delta Air Lines'', ''DL''),
    (''United Airlines'', ''UA'');
END;' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generateFlights(amount INT) RETURNS VOID AS '
DECLARE
  dateStart TIMESTAMP;
  errors INT;
BEGIN
  errors := 0;

  FOR i IN 1..amount LOOP
    dateStart := (SELECT TIMESTAMP ''2017-01-10 20:00:00'' +
                         random() * (TIMESTAMP ''2017-03-20 20:00:00'' -
                                     TIMESTAMP ''2017-01-10 10:00:00''));
    BEGIN
      INSERT INTO Flights (fromAirport, toAirport, dateStart, dateEnd, airline) VALUES
        (
          (SELECT id FROM Airports OFFSET floor(random() * (SELECT count(*) FROM Airports)) LIMIT 1),
          (SELECT id FROM Airports OFFSET floor(random() * (SELECT count(*) FROM Airports)) LIMIT 1),
          dateStart,
          dateStart + random() * (TIMESTAMP ''2014-01-10 20:00:00'' -
                                  TIMESTAMP ''2014-01-10 10:00:00''),
          (SELECT id FROM Airlines OFFSET floor(random() * (SELECT count(*) FROM Airlines)) LIMIT 1)
        );
    EXCEPTION WHEN check_violation THEN
      errors := errors + 1;
    END;
  END LOOP;

  IF errors > 0 THEN
    PERFORM generateFlights(errors);
  END IF;
END;' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generateOrders(amount INT) RETURNS VOID AS 'BEGIN
  FOR i IN 1..amount LOOP
    CREATE TEMPORARY TABLE flight AS
      (SELECT * FROM Flights OFFSET floor(random() * (SELECT count(*) FROM Users)) LIMIT 1);

    INSERT INTO Orders (client, date, flight) VALUES
      (
        (SELECT id FROM Users OFFSET floor(random() * (SELECT count(*) FROM Users)) LIMIT 1),
        (SELECT dateStart FROM flight)::TIMESTAMP - random() * (TIMESTAMP ''2014-02-01 10:00:00'' -
          TIMESTAMP ''2014-01-10 10:00:00'') - (TIMESTAMP ''2014-01-10 10:00:00'' -
                                                TIMESTAMP ''2014-01-01 10:00:00''),
        ARRAY[]::INT[] || (SELECT id FROM flight)
      );

    DROP TABLE flight;
  END LOOP;
END;' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generateUsers(amount INT) RETURNS VOID AS 'BEGIN EXECUTE ''
  CREATE TEMPORARY TABLE firstNamesM (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO firstNamesM (value) VALUES
    (''''Игорь''''), (''''Рудольф''''), (''''Аркадий''''), (''''Виталий''''), (''''Михаил''''), (''''Олег''''), (''''Ахмед''''), (''''Азриель'''');

  CREATE TEMPORARY TABLE lastNamesM (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO lastNamesM (value) VALUES
    (''''Бездольный''''), (''''Глыбочко''''), (''''Горбачёв''''), (''''Капков''''), (''''Капура''''), (''''Долин''''), (''''Леонов'''');

  CREATE TEMPORARY TABLE midNamesM (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO midNamesM (value) VALUES
    (''''Семёнович''''), (''''Алексеевич''''), (''''Юрьевич''''), (''''Магомедович''''), (''''Филиппович''''), (''''Эдуардович'''');

  CREATE TEMPORARY TABLE firstNamesF (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO firstNamesF (value) VALUES
    (''''Мая''''), (''''Мария''''), (''''Людмила''''), (''''Любовь''''), (''''Изольда''''), (''''Анастасия''''), (''''Елизавета'''');

  CREATE TEMPORARY TABLE lastNamesF (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO lastNamesF (value) VALUES
    (''''Бездольная''''), (''''Глыбочко''''), (''''Горбачёва''''), (''''Капкова''''), (''''Капура''''), (''''Долина''''), (''''Леонова'''');

  CREATE TEMPORARY TABLE midNamesF (value TEXT) ON COMMIT DELETE ROWS;
  INSERT INTO midNamesF (value) VALUES
    (''''Семёновна''''), (''''Алексеевна''''), (''''Юрьевна''''), (''''Магомедовна''''), (''''Филипповна''''), (''''Эдуардовна'''');'';

  FOR i IN 1..amount LOOP
    IF (SELECT random()) > 0.5 THEN EXECUTE ''
      INSERT INTO Users (firstName, lastName, midName, document) VALUES
        (
          (SELECT value FROM firstNamesM OFFSET floor(random() * (SELECT count(*) FROM firstNamesM)) LIMIT 1),
          (SELECT value FROM lastNamesM OFFSET floor(random() * (SELECT count(*) FROM lastNamesM)) LIMIT 1),
          (SELECT value FROM midNamesM OFFSET floor(random() * (SELECT count(*) FROM midNamesM)) LIMIT 1),
          (SELECT trunc(random() * 999999999 + 100000000))
        );
    ''; ELSE EXECUTE ''
      INSERT INTO Users (firstName, lastName, midName, document) VALUES
        (
          (SELECT value FROM firstNamesF OFFSET floor(random() * (SELECT count(*) FROM firstNamesF)) LIMIT 1),
          (SELECT value FROM lastNamesF OFFSET floor(random() * (SELECT count(*) FROM lastNamesF)) LIMIT 1),
          (SELECT value FROM midNamesF OFFSET floor(random() * (SELECT count(*) FROM midNamesF)) LIMIT 1),
          (SELECT trunc(random() * 999999999 + 100000000))
        );
    ''; END IF;
  END LOOP;
END; ' LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION flightCheck() RETURNS TRIGGER AS 'BEGIN
  IF (SELECT city FROM Airports WHERE id = NEW.toAirport) =
     (SELECT city FROM Airports WHERE id = NEW.fromAirport) THEN
    RAISE EXCEPTION check_violation;
  END IF;

  IF (NEW.dateEnd - NEW.dateStart) < (TIMESTAMP ''2014-01-01 11:00:00'' - TIMESTAMP ''2014-01-01 10:00:00'') THEN
    RAISE EXCEPTION check_violation;
  END IF;

  RETURN NEW;
END;' LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS onFlightChange ON Flights;
CREATE TRIGGER onFlightChange BEFORE INSERT OR UPDATE ON Flights FOR EACH ROW EXECUTE PROCEDURE flightCheck();


SELECT generateCities();
SELECT generateAirports();
SELECT generateAirlines();
SELECT generateFlights(10000);
SELECT generateUsers(50);
SELECT generateOrders(10);



CREATE VIEW flightsFromCity AS (
    SELECT
      Flights.id AS id, fromAirport, toAirport, dateStart, dateEnd, airline,
      FromAirports.code AS fromAirportCode,
      ToAirports.code AS toAirportCode,
      Airlines.name AS airlineName,
      Airlines.code AS airlineCode,
      Cities.id AS city,
      Cities.name AS cityName,
      dateEnd - dateStart AS duration
    FROM
      Flights
      JOIN Airports AS FromAirports ON fromAirport = FromAirports.id
      JOIN Airports AS ToAirports ON toAirport = ToAirports.id
      JOIN Airlines ON airline = Airlines.id
      JOIN Cities ON FromAirports.city = Cities.id
);



CREATE VIEW clientOrders AS (
    SELECT
      Orders.id AS id, client, date, flight, reverse,
      (Users.lastName || ' '::TEXT || Users.firstName || ' '::TEXT || Users.midName) AS clientName,
      Flights.id AS flightId,
      Flights.dateStart AS flightStart,
      Flights.dateEnd AS flightEnd,
      Airlines.code AS airlineCode,
      Airlines.name AS airlineName,
      FromAirport.code AS fromAirportCode,
      FromAirport.name AS fromAirportName,
      ToAirport.code AS toAirportCode,
      ToAirport.name AS toAirportName,
      FromCity.name AS fromCityName,
      FromCity.country AS fromCityCountry,
      ToCity.name AS toCityName,
      ToCity.country AS toCityCountry
    FROM
      Orders
      JOIN Users ON Orders.client = Users.id
      JOIN Flights ON Orders.flight[1] = Flights.id
      JOIN Airlines ON Flights.airline = Airlines.id
      JOIN Airports AS FromAirport ON Flights.fromAirport = FromAirport.id
      JOIN Airports AS ToAirport ON Flights.toAirport = ToAirport.id
      JOIN Cities AS FromCity ON FromAirport.city = FromCity.id
      JOIN Cities AS ToCity ON ToAirport.city = ToCity.id
);


CREATE VIEW flightsFromCityToCity AS (
  SELECT
    Flights.id AS id, fromAirport, toAirport, dateStart, dateEnd, airline,
    FromAirports.code AS fromAirportCode,
    ToAirports.code AS toAirportCode,
    Airlines.name AS airlineName,
    Airlines.code AS airlineCode,
    FromCity.name AS fromCityName, FromCity.id AS fromCityId,
    ToCity.name AS toCityName, ToCity.id AS toCityId,
    dateEnd - dateStart AS duration
  FROM
    Flights
    JOIN Airports AS FromAirports ON fromAirport = FromAirports.id
    JOIN Airports AS ToAirports ON toAirport = ToAirports.id
    JOIN Airlines ON airline = Airlines.id
    JOIN Cities AS FromCity ON FromAirports.city = FromCity.id
    JOIN Cities AS ToCity ON ToAirports.city = ToCity.id
  ORDER BY
    duration ASC
);



