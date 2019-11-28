CREATE SCHEMA computerparts DEFAULT CHARACTER SET unicode;
USE computerparts;

CREATE TABLE motherboard (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, ram_slots int NOT NULL, ram_type int NOT NULL, form_factor int NOT NULL, socket int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE cpu (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, motherboard_sn int NOT NULL, tdp int NOT NULL, core_count int NOT NULL, smt int NOT NULL, socket int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE cpu_cooler (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, motherboard_sn int NOT NULL, fan_rpm int NOT NULL, noise_level int NOT NULL, socket int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE gpu (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, motherboard_sn int NOT NULL, core_clock int NOT NULL, memory int NOT NULL, gpu_length int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE case (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, motherboard_sn int NOT NULL, psu_sn int NOT NULL, gpu_space int NOT NULL, storage_bays int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE psu (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, wattage int NOT NULL, modular int NOT NULL, efficiency_rating int NOT NULL, form_factor int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE storage (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, case_sn int NOT NULL, capacity int NOT NULL, interface int NOT NULL, form_factor int NOT NULL,PRIMARY KEY (serial_number));

CREATE TABLE storage (serial_number varchar(50) NOT NULL, name varchar(10) NOT NULL, case_sn int NOT NULL, capacity int NOT NULL, interface int NOT NULL, form_factor int NOT NULL,PRIMARY KEY (serial_number));