-- noinspection SqlNoDataSourceInspectionForFile


DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Airports;
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


CREATE TABLE IF NOT EXISTS Airports (
  id SERIAL PRIMARY KEY,
  city INT REFERENCES Cities,
  name TEXT,
  code TEXT
);


CREATE TABLE IF NOT EXISTS Orders (
  id SERIAL PRIMARY KEY,
  client INT REFERENCES Users,
  dateOrdered TIMESTAMPTZ,
  dateFlying TIMESTAMPTZ,
  cityFrom INT REFERENCES Cities,
  cityTo INT REFERENCES Cities
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

  FOR i in 0..amount LOOP
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


SELECT generateCities();
SELECT generateAirports();
SELECT generateUsers(50);
