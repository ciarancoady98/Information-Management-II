DROP DATABASE [IF EXISTS] computerparts;
CREATE DATABASE computerparts;
USE computerparts;

CREATE TABLE motherboard (
    serial_number varchar(10) NOT NULL, 
    name varchar(50), ram_slots int NOT NULL, 
    ram_type varchar(4) NOT NULL, 
    form_factor varchar(5) NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number),
    );

CREATE TABLE central_processing_unit (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL,
    tdp int NOT NULL, 
    core_count int NOT NULL, 
    smt varchar(3) NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  );

CREATE TABLE cpu_cooler (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    fan_rpm int NOT NULL, 
    noise_level int NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE graphics_processing_unit (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    core_clock int NOT NULL, 
    memory int NOT NULL, 
    gpu_length int NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE computer_case (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    psu_sn varchar(10) NOT NULL, 
    gpu_space int NOT NULL, 
    storage_bays int NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE power_supply (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    wattage int NOT NULL, 
    modular int NOT NULL, 
    efficiency_rating int NOT NULL, 
    form_factor varchar(4) NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE storage_drive (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    case_sn varchar(10) NOT NULL, 
    capacity int NOT NULL, 
    interface varchar(4) NOT NULL, 
    form_factor varchar(4) NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE random_access_memory (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    capacity int NOT NULL, 
    number_of_modules int NOT NULL, 
    type varchar(4) NOT NULL,
    PRIMARY KEY (serial_number));

CREATE TABLE cooling (
    cpu_sn varchar(10) NOT NULL, 
    cooler_sn varchar(50) NOT NULL,
    PRIMARY KEY (cpu_sn, cooler_sn));