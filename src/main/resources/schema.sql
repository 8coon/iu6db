-- noinspection SqlNoDataSourceInspectionForFile

DROP VIEW IF EXISTS flightsFromCity;
DROP VIEW IF EXISTS clientOrders;
DROP VIEW IF EXISTS flightsFromCityToCity;
DROP VIEW IF EXISTS clients;
DROP VIEW IF EXISTS orderDetails;
DROP VIEW IF EXISTS shortFlights;
DROP TABLE IF EXISTS OrderFlights;
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
  reverse INT REFERENCES Orders DEFAULT NULL
);


CREATE TABLE IF NOT EXISTS OrderFlights (
  "order" INT REFERENCES Orders,
  flight INT REFERENCES Flights
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
    dateStart := (SELECT TIMESTAMP ''2017-05-20 20:00:00'' +
                         random() * (TIMESTAMP ''2017-05-20 20:00:00'' -
                                     TIMESTAMP ''2017-06-10 10:00:00''));
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


CREATE OR REPLACE FUNCTION generateOrders(amount INT) RETURNS VOID AS '
DECLARE
  nextId INT;
BEGIN
  FOR i IN 1..amount LOOP
    CREATE TEMPORARY TABLE flight AS
      (SELECT * FROM Flights OFFSET floor(random() * (SELECT count(*) FROM Flights)) LIMIT 1);

    nextId := (SELECT nextval(''orders_id_seq''));

    INSERT INTO Orders (client, date, id) VALUES
      (
        (SELECT id FROM Users OFFSET floor(random() * (SELECT count(*) FROM Users)) LIMIT 1),
        (SELECT dateStart FROM flight)::TIMESTAMP - random() * (TIMESTAMP ''2014-02-01 10:00:00'' -
          TIMESTAMP ''2014-01-10 10:00:00'') - (TIMESTAMP ''2014-01-10 10:00:00'' -
                                                TIMESTAMP ''2014-01-01 10:00:00''), nextId
      );

    INSERT INTO OrderFlights ("order", flight) VALUES (nextId, (SELECT id FROM flight));

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
SELECT generateUsers(10);
SELECT generateOrders(10);



CREATE VIEW flightsFromCity AS (
    SELECT
      Flights.id AS id, fromAirport, toAirport, dateStart, dateEnd, airline,
      FromAirports.code AS fromAirportCode,
      ToAirports.code AS toAirportCode,
      FromAirports.name AS fromAirportName,
      ToAirports.name AS toAirportName,
      Airlines.name AS airlineName,
      Airlines.code AS airlineCode,
      Cities.id AS city,
      Cities.name AS cityName,
      Cities.country AS cityCountry,
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
    t.id AS id, client, date, reverse, flights,
    (Users.lastName || ' '::TEXT || Users.firstName || ' '::TEXT || Users.midName) AS clientName,
    Airlines.code AS airlineCode,
    Airlines.name AS airlineName,
    FromAirport.code AS fromAirportCode,
    FromAirport.name || ', '::TEXT || FromCity.name || ', ' || FromCity.country AS fromAirportName,
    ToAirport.code AS toAirportCode,
    ToAirport.name || ', '::TEXT || ToCity.name || ', ' || ToCity.country AS toAirportName,
    FirstFlight.dateStart AS flightStart
  FROM
    (
      SELECT
        Orders.id AS id, client, date, reverse,
        array_agg((SELECT flight FROM OrderFlights WHERE "order" = Orders.id)) AS flights
      FROM
        Orders
      GROUP BY
        Orders.id
      ORDER BY
        date
    ) AS t
    JOIN Users ON t.client = Users.id
    JOIN Flights AS FirstFlight ON flights[1] = FirstFlight.id
    JOIN Flights AS LastFlight ON flights[array_length(flights, 1)] = LastFlight.id
    JOIN Airlines ON FirstFlight.airline = Airlines.id
    JOIN Airports AS FromAirport ON FirstFlight.fromAirport = FromAirport.id
    JOIN Airports AS ToAirport ON LastFlight.toAirport = ToAirport.id
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



CREATE OR REPLACE FUNCTION connectingFlights(f INT, t INT, d TIMESTAMPTZ) RETURNS TABLE
  (
    length INT,
    F1_id INT, F1_fromCity INT, F1_toCity INT,
    F1_dateStart TIMESTAMP,
    F1_dateEnd TIMESTAMP,
    F1_fromAirportCode TEXT,
    F1_toAirportCode TEXT,
    F1_fromAirportName TEXT,
    F1_toAirportName TEXT,
    F1_airlineName TEXT,
    F1_airlineCode TEXT,
    F1_cityName TEXT,
    F1_cityCountry TEXT,
    F2_id INT, F2_fromCity INT, F2_toCity INT,
    F2_dateStart TIMESTAMP,
    F2_dateEnd TIMESTAMP,
    F2_fromAirportCode TEXT,
    F2_toAirportCode TEXT,
    F2_fromAirportName TEXT,
    F2_toAirportName TEXT,
    F2_airlineName TEXT,
    F2_airlineCode TEXT,
    F2_cityName TEXT,
    F2_cityCountry TEXT,
    F3_id INT, F3_fromCity INT, F3_toCity INT,
    F3_dateStart TIMESTAMP,
    F3_dateEnd TIMESTAMP,
    F3_fromAirportCode TEXT,
    F3_toAirportCode TEXT,
    F3_fromAirportName TEXT,
    F3_toAirportName TEXT,
    F3_airlineName TEXT,
    F3_airlineCode TEXT,
    F3_cityName TEXT,
    F3_cityCountry TEXT
  ) AS '
BEGIN
  RETURN QUERY (
    SELECT
      t.length AS "length",
      t.F1_id AS F1_id,
      t.F1_fromCity AS F1_fromCity,
      t.F1_toCity AS F1_toCity,
        F1.dateStart AS F1_dateStart,
        F1.dateEnd AS F1_dateEnd,
        F1.fromAirportCode AS F1_fromAirportCode,
        F1.toAirportCode AS F1_toAirportCode,
        F1.fromAirportName AS F1_fromAirportName,
        F1.toAirportName AS F1_toAirportName,
        F1.airlineName AS F1_airlineName,
        F1.airlineCode AS F1_airlineCode,
        F1.cityName AS F1_cityName,
        F1.cityCountry AS F1_cityCountry,

      t.F2_id AS F2_id,
      t.F2_fromCity AS F2_fromCity,
      t.F2_toCity AS F2_toCity,
        F2.dateStart AS F2_dateStart,
        F2.dateEnd AS F2_dateEnd,
        F2.fromAirportCode AS F2_fromAirportCode,
        F2.toAirportCode AS F2_toAirportCode,
        F2.fromAirportName AS F2_fromAirportName,
        F2.toAirportName AS F2_toAirportName,
        F2.airlineName AS F2_airlineName,
        F2.airlineCode AS F2_airlineCode,
        F2.cityName AS F2_cityName,
        F2.cityCountry AS F2_cityCountry,
  
      t.F3_id AS F3_id,
      t.F3_fromCity AS F3_fromCity,
      t.F3_toCity AS F3_toCity,
        F3.dateStart AS F3_dateStart,
        F3.dateEnd AS F3_dateEnd,
        F3.fromAirportCode AS F3_fromAirportCode,
        F3.toAirportCode AS F3_toAirportCode,
        F3.fromAirportName AS F3_fromAirportName,
        F3.toAirportName AS F3_toAirportName,
        F3.airlineName AS F3_airlineName,
        F3.airlineCode AS F3_airlineCode,
        F3.cityName AS F3_cityName,
        F3.cityCountry AS F3_cityCountry
    FROM
        (SELECT
             F1.id       AS F1_id,
             F1.fromCity AS F1_fromCity,
             F1.toCity   AS F1_toCity,
             0           AS F2_id,
             0           AS F2_fromCity,
             0           AS F2_toCity,
             0           AS F3_id,
             0           AS F3_fromCity,
             0           AS F3_toCity,
             1           AS length
         FROM
             shortFlights AS F1
         WHERE
             F1.fromCity = f AND F1.toCity = t AND date_trunc(''day'', F1.dateStart) = date_trunc(''day'', d)


         UNION ALL


         SELECT
             F1.id       AS F1_id,
             F1.fromCity AS F1_fromCity,
             F1.toCity   AS F1_toCity,
             F2.id       AS F2_id,
             F2.fromCity AS F2_fromCity,
             F2.toCity   AS F2_toCity,
             0           AS F3_id,
             0           AS F3_fromCity,
             0           AS F3_toCity,
             2           AS length
         FROM
             shortFlights AS F1, shortFlights AS F2
         WHERE
             F1.fromCity = f AND F2.toCity = t AND F1.toCity = F2.fromCity AND
             date_trunc(''day'', F1.dateStart) = date_trunc(''day'', d) AND
             F2.dateEnd > F1.dateStart AND
             F2.dateStart - F1.dateEnd > INTERVAL ''1 hour'' AND
             F2.dateStart - F1.dateEnd < INTERVAL ''10 hours''


         UNION ALL


         SELECT
             F1.id       AS F1_id,
             F1.fromCity AS F1_fromCity,
             F1.toCity   AS F1_toCity,
             F2.id       AS F2_id,
             F2.fromCity AS F2_fromCity,
             F2.toCity   AS F2_toCity,
             F3.id       AS F3_id,
             F3.fromCity AS F3_fromCity,
             F3.toCity   AS F3_toCity,
             3           AS length
         FROM
             shortFlights AS F1, shortFlights AS F2, shortflights AS F3
         WHERE
             F1.fromCity = f AND F3.toCity = t AND F1.toCity = F2.fromCity AND F2.toCity = F3.fromCity AND
             date_trunc(''day'', F1.dateStart) = date_trunc(''day'', d) AND
             F2.dateEnd > F1.dateStart AND
             F2.dateStart - F1.dateEnd > INTERVAL ''1 hour'' AND
             F2.dateStart - F1.dateEnd < INTERVAL ''10 hours'' AND
             F3.dateEnd > F2.dateStart AND
             F3.dateStart - F2.dateEnd > INTERVAL ''1 hour'' AND
             F3.dateStart - F2.dateEnd < INTERVAL ''10 hours''
        ) AS t
      LEFT OUTER JOIN flightsFromCity AS F1 ON F1.id = t.F1_id
      LEFT OUTER JOIN flightsFromCity AS F2 ON F2.id = t.F2_id
      LEFT OUTER JOIN flightsFromCity AS F3 ON F3.id = t.F3_id
    ORDER BY F1.duration, F2.duration, F3.duration
  );
END;' LANGUAGE plpgsql;



CREATE VIEW clients AS (
  SELECT
    id, (lastName || ' '::TEXT || firstName || ' '::TEXT || midName) AS name
  FROM
    Users
  ORDER BY
    id
);


CREATE VIEW orderDetails AS (
  SELECT
    "order", flight AS id,
    Orders.date AS orderDate,
    Flights.dateStart AS dateStart,
    Flights.dateEnd AS dateEnd,
    FromAirports.code AS fromAirportCode,
    ToAirports.code AS toAirportCode,
    FromAirports.name || ', '::TEXT || FromCity.name || ', ' || FromCity.country AS fromAirportName,
    ToAirports.name || ', '::TEXT || ToCity.name || ', ' || ToCity.country AS toAirportName,
    Airlines.name AS airlineName,
    Airlines.code AS airlineCode
  FROM
    OrderFlights
    JOIN Orders ON OrderFlights."order" = Orders.id
    JOIN Flights ON OrderFlights.flight = Flights.id
    JOIN Airports AS FromAirports ON Flights.fromAirport = FromAirports.id
    JOIN Airports AS ToAirports ON Flights.toAirport = ToAirports.id
    JOIN Cities AS FromCity ON FromAirports.city = FromCity.id
    JOIN Cities AS ToCity ON ToAirports.city = ToCity.id
    JOIN Airlines ON Flights.airline = Airlines.id
  ORDER BY
    dateStart
);


CREATE VIEW shortFlights AS (
  SELECT
    Flights.id AS id,
    fromAirport.city AS fromCity,
    toAirport.city AS toCity,
    Flights.dateStart AS dateStart,
    Flights.dateEnd AS dateEnd
  FROM
    Flights
    JOIN Airports AS FromAirport ON Flights.fromAirport = FromAirport.id
    JOIN Airports AS ToAirport ON Flights.toAirport = ToAirport.id
  ORDER BY
    Flights.datestart
);


