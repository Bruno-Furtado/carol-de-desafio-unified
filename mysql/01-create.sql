CREATE SCHEMA openflights;

USE openflights;

CREATE TABLE airports (
    airport_id INT NOT NULL,
    name VARCHAR(300) NOT NULL,
    city VARCHAR(300),
    country VARCHAR(150) NOT NULL,
    iata VARCHAR(3),
    icao VARCHAR(4),
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    altitude INT NOT NULL,
    timezone FLOAT,
    dst VARCHAR(1),
    tz_database_time_zone VARCHAR(150),
    type VARCHAR(150) NOT NULL,
    source VARCHAR(150) NOT NULL,
    PRIMARY KEY (airport_id)
);

CREATE TABLE airlines (
    airline_id INT NOT NULL,
    name VARCHAR(300) NOT NULL,
    alias VARCHAR(150),
    iata VARCHAR(2),
    icao VARCHAR(3),
    callsign VARCHAR(150),
    city VARCHAR(300),
    active VARCHAR(1) NOT NULL,
    PRIMARY KEY (airline_id)
);

CREATE TABLE routes (
    route_id INT NOT NULL AUTO_INCREMENT,
    airline VARCHAR(3),
    airline_id INT,
    source_airport VARCHAR(3),
    source_airport_id INT,
    destination_airport VARCHAR(3),
    destination_airport_id INT,
    codeshare VARCHAR(1),
    stops INT NOT NULL,
    equipment VARCHAR(150),
    PRIMARY KEY (route_id)
);
