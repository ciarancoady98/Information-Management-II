DROP DATABASE [IF EXISTS] computerparts;
CREATE DATABASE computerparts;
USE computerparts;

CREATE TABLE motherboard (
    serial_number varchar(10) NOT NULL, 
    name varchar(50), ram_slots int NOT NULL, 
    ram_type varchar(4) NOT NULL, 
    form_factor varchar(5) NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number)
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
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE graphics_processing_unit (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    core_clock int NOT NULL, 
    memory int NOT NULL, 
    gpu_length int NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE power_supply (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    wattage int NOT NULL, 
    modular varchar(3) NOT NULL, 
    efficiency_rating varchar(8) NOT NULL, 
    form_factor varchar(5) NOT NULL,
    PRIMARY KEY (serial_number)
    );

CREATE TABLE computer_case (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    psu_sn varchar(10) NOT NULL, 
    gpu_space int NOT NULL, 
    storage_bays varchar(7) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (psu_sn) 
    REFERENCES power_supply(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE storage_drive (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    case_sn varchar(10) NOT NULL, 
    capacity int NOT NULL, 
    interface varchar(4) NOT NULL, 
    form_factor varchar(7) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (case_sn) 
    REFERENCES computer_case(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE random_access_memory (
    serial_number varchar(10) NOT NULL, 
    name varchar(50) NOT NULL, 
    motherboard_sn varchar(10) NOT NULL, 
    capacity int NOT NULL, 
    number_of_modules int NOT NULL, 
    type varchar(4) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE cooling (
    cpu_sn varchar(10) NOT NULL, 
    cooler_sn varchar(50) NOT NULL,
    PRIMARY KEY (cpu_sn, cooler_sn));

#Insert entries into the motherboard table
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("M123456781", "Asus Prime x370", 4, "ddr4", "atx", "am4");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("M123456782", "Gigabyte ds3h", 4, "ddr3", "atx", "lga1155");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("M123456783", "Asus x99-pro", 8, "ddr4", "atx", "lga2011v3");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("M123456784", "Aus ROG Zenith Extreme", 8, "ddr4", "e-atx", "tr4");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("M123456785", "Aorus pro ac wifi ", 2, "ddr4", "m-itx", "am4");

#Insert entries into the cpu table
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("C123456781", "Amd Ryzen 5 1600", "M123456781", 65, 6, "yes", "am4");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("C123456782", "Intel Core i5 3570k", "M123456782", 77, 4, "no", "lga1155");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("C123456783", "Intel Core i7 5820k", "M123456783", 140, 6, "yes", "lga2011v3");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("C123456784", "Amd Threadripper 3970X", "M123456784", 280 , 32, "yes", "tr4");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("C123456785", "Amd Ryzen 7 1800x", "M123456785", 95, 8, "yes", "am4");

#Insert entries into the cpu cooler table
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("CC12345671", "Corsair h100i", "M123456781", 2200, 20, "am4");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("CC12345672", "Intel Stock Cooler", "M123456782", 1200, 30, "lga1155");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("CC12345673", "EK Supremecy Evo", "M123456783", 2200, 15, "lga2011v3");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("CC12345674", "Dual stack noctua cooler", "M123456784", 1800, 35, "tr4");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("CC12345675", "NZXT Kraken", "M123456785", 2200, 20, "am4");

    #Insert entries into the gpu table
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("G123456781", "Asus Geforce Gtx 970", "M123456781", 1114, 4, 280);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("G123456782", "Gigabyte Geforce Gtx 650ti", "M123456782", 928, 1, 144);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("G123456783", "Nvidia Quadro GV100", "M123456783", 1132, 32, 266);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("G123456784", "Amd Radeon VII", "M123456784", 1400, 16, 305);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("G123456785", "Amd r9 290x", "M123456785", 1000, 4, 276);

#Insert entries into the psu table
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("P123456781", "Corsair cx600m", 600, "yes", "bronze", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("P123456782", "Evga br500", 500, "no", "bronze", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("P123456783", "Corsair rm850x", 850, "yes", "gold", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("P123456784", "Corsair ax1200i", 1200, "yes", "platinum", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("P123456785", "Silverstone SX600G", 600, "yes", "gold", "m-itx");

#Insert entries into the case table
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("CE12345671", "Fractal Design Define S", "M123456781", "P123456781", "400", "2.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("CE12345672", "Fractal Design Define R5", "M123456782", "P123456782", "310", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("CE12345673", "Zalman z11 plus", "M123456783", "P123456783", "290", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("CE12345674", "Nzxt h440", "M123456784", "P123456784", "294", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("CE12345675", "Ncase M1", "M123456785", "P123456785", "280", "2.5inch");


#Insert entries into the storage table
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("S123456781", "Samsung 850 Evo", "CE12345671", 500, "sata", "2.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("S123456782", "Western Digital Caviar Green 1tb", "CE12345672", 1000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("S123456783", "Seagate Barracuda 2tb", "CE12345673", 2000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("S123456784", "Samsung HD105SI", "CE12345674", 1000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("S123456785", "Intel 730", "CE12345675", 240, "sata", "2.5inch");

#Insert entries into ram table
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R123456781", "Corsair Vengeance LPX", "M123456781", 16, 2, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R123456782", "G Skill Ripjaws", "M123456782", 8, 1, "ddr3");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R123456783", "Corsair Vengeance RGB", "M123456783", 16, 2, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R123456784", "Corsair Vengeance LPX", "M123456784", 128, 8, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R123456785", "Crucial Ballistix LT", "M123456785", 32, 2, "ddr4");