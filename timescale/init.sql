create user hcrl with superuser password 'hcrl';

-- Users
CREATE TABLE IF NOT EXISTS users (
    id uuid NOT NULL,
    username VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    fname VARCHAR NOT NULL,
    lname VARCHAR NOT NULL,
    role SMALLINT NOT NULL,

    PRIMARY KEY (id),
    UNIQUE (username)
);

-- Location
CREATE TABLE IF NOT EXISTS location (
    location_name VARCHAR NOT NULL,
    PRIMARY KEY (location_name)
);

-- Device
CREATE TABLE IF NOT EXISTS device (
    device_id uuid NOT NULL,
    location_name VARCHAR NOT NULL,
    device_name VARCHAR NOT NULL,
    device_type VARCHAR NOT NULL,
    timezone SMALLINT NOT NULL,
    date_added TIMESTAMP NOT NULL,

    PRIMARY KEY (device_id),
    FOREIGN KEY (location_name) REFERENCES location(location_name)
);

-- Element
CREATE TABLE IF NOT EXISTS element (
    device_id uuid NOT NULL,
    element_id VARCHAR NOT NULL,
    element_name VARCHAR NOT NULL,
    unit VARCHAR NOT NULL,
    icon VARCHAR NOT NULL,

    PRIMARY KEY (device_id, element_id),
    FOREIGN KEY (device_id) REFERENCES device(device_id)
);

-- Time series
CREATE TABLE IF NOT EXISTS timeseries (
    timestamp timestamp NOT NULL,
    device_id uuid NOT NULL,
    element_id VARCHAR NOT NULL,
    firmware_version VARCHAR NOT NULL,
    operation_time_since timestamp NOT NULL,
    value NUMERIC(16, 7) NOT NULL
);

SELECT create_hypertable('timeseries', 'timestamp', if_not_exists => TRUE, chunk_time_interval => INTERVAL '6 hours');

CREATE INDEX ON timeseries (device_id, element_id, timestamp DESC);
