DROP DATABASE IF EXISTS computerparts;
CREATE DATABASE computerparts;
USE computerparts;

#Define tables and constraints 
CREATE TABLE motherboard (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    ram_slots int NOT NULL CHECK (ram_slots > 0), 
    ram_type varchar(4) NOT NULL, 
    form_factor varchar(5) NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number)
    );

CREATE TABLE central_processing_unit (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    motherboard_sn varchar(12) NOT NULL,
    tdp int NOT NULL, 
    core_count int NOT NULL CHECK (core_count > 0), 
    smt varchar(3) NOT NULL, 
    socket varchar(10) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  );

CREATE TABLE cpu_cooler (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    motherboard_sn varchar(12) NOT NULL, 
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
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    motherboard_sn varchar(12) NOT NULL, 
    core_clock int NOT NULL, 
    memory int NOT NULL, 
    gpu_length int NOT NULL CHECK (gpu_length > 0),
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE power_supply (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    wattage int NOT NULL, 
    modular varchar(3) NOT NULL, 
    efficiency_rating varchar(8) NOT NULL, 
    form_factor varchar(5) NOT NULL,
    PRIMARY KEY (serial_number)
    );

CREATE TABLE computer_case (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    motherboard_sn varchar(12) NOT NULL, 
    psu_sn varchar(12) NOT NULL, 
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
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    case_sn varchar(12) NOT NULL, 
    capacity int NOT NULL CHECK (capacity > 0), 
    interface varchar(4) NOT NULL, 
    form_factor varchar(7) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (case_sn) 
    REFERENCES computer_case(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE random_access_memory (
    serial_number varchar(12) NOT NULL, 
    name varchar(50), 
    motherboard_sn varchar(12) NOT NULL, 
    capacity int NOT NULL, 
    number_of_modules int NOT NULL CHECK (number_of_modules > 0), 
    type varchar(4) NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (motherboard_sn) 
    REFERENCES motherboard(serial_number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE cooling (
    cpu_sn varchar(12) NOT NULL, 
    cooler_sn varchar(12) NOT NULL,
    PRIMARY KEY (cpu_sn, cooler_sn));

#Create restricted views for security and different access levels
CREATE VIEW motherboard_released 
AS SELECT serial_number, name , ram_slots, ram_type, form_factor, socket 
FROM motherboard 
WHERE serial_number LIKE "R-%";

CREATE VIEW central_processing_unit_released 
AS SELECT serial_number, name, motherboard_sn, tdp, core_count, smt, socket 
FROM central_processing_unit 
WHERE serial_number LIKE "R-%" 
AND motherboard_sn LIKE "R-%";

CREATE VIEW cpu_cooler_released 
AS SELECT serial_number, name, motherboard_sn, fan_rpm, noise_level, socket 
FROM cpu_cooler 
WHERE serial_number LIKE "R-%"
AND motherboard_sn LIKE "R-%";

CREATE VIEW graphics_processing_unit_released 
AS SELECT serial_number, name, motherboard_sn, core_clock, memory, gpu_length 
FROM graphics_processing_unit 
WHERE serial_number LIKE "R-%"
AND motherboard_sn LIKE "R-%";

CREATE VIEW power_supply_released 
AS SELECT serial_number, name, wattage, modular, efficiency_rating, form_factor 
FROM power_supply 
WHERE serial_number LIKE "R-%";

CREATE VIEW computer_case_released 
AS SELECT serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays 
FROM computer_case 
WHERE serial_number LIKE "R-%"
AND motherboard_sn LIKE "R-%"
AND psu_sn LIKE "R-%";

CREATE VIEW storage_drive_released 
AS SELECT serial_number, name, case_sn, capacity, interface, form_factor 
FROM storage_drive 
WHERE serial_number LIKE "R-%";

CREATE VIEW random_access_memory_released 
AS SELECT serial_number, name, motherboard_sn, capacity, number_of_modules, type 
FROM random_access_memory 
WHERE serial_number LIKE "R-%"
AND motherboard_sn LIKE "R-%";

#Create roles for different access levels
CREATE ROLE staff;
CREATE ROLE customer;

#Set permissions for staff
GRANT ALL ON motherboard TO staff;
GRANT ALL ON central_processing_unit TO staff;
GRANT ALL ON cpu_cooler TO staff;
GRANT ALL ON graphics_processing_unit TO staff;
GRANT ALL ON power_supply TO staff;
GRANT ALL ON computer_case TO staff;
GRANT ALL ON storage_drive TO staff;
GRANT ALL ON random_access_memory TO staff;
GRANT ALL ON cooling TO staff;
GRANT ALL ON motherboard_released TO staff;
GRANT ALL ON central_processing_unit_released TO staff;
GRANT ALL ON cpu_cooler_released TO staff;
GRANT ALL ON graphics_processing_unit_released TO staff;
GRANT ALL ON power_supply_released TO staff;
GRANT ALL ON computer_case_released TO staff;
GRANT ALL ON storage_drive_released TO staff;
GRANT ALL ON random_access_memory_released TO staff;

#Set permissions for customer
GRANT SELECT ON motherboard_released TO customer;
GRANT SELECT ON central_processing_unit_released TO customer;
GRANT SELECT ON cpu_cooler_released TO customer;
GRANT SELECT ON graphics_processing_unit_released TO customer;
GRANT SELECT ON power_supply_released TO customer;
GRANT SELECT ON computer_case_released TO customer;
GRANT SELECT ON storage_drive_released TO customer;
GRANT SELECT ON random_access_memory_released TO customer;

#Create semantic constraints
#Trigger will set the names of inserted cpus that are null
CREATE TRIGGER set_default_cpu_name BEFORE UPDATE ON central_processing_unit
     FOR EACH ROW
     BEGIN
         IF NEW.name IS NULL THEN
             SET NEW.name = "undecided";
         END IF;
    END;



#Insert entries into the motherboard table
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("R-M123456781", "Asus Prime x370", 4, "ddr4", "atx", "am4");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("R-M123456782", "Gigabyte ds3h", 4, "ddr3", "atx", "lga1155");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("R-M123456783", "Asus x99-pro", 8, "ddr4", "atx", "lga2011v3");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("R-M123456784", "Aus ROG Zenith Extreme", 8, "ddr4", "e-atx", "tr4");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("R-M123456785", "Aorus pro ac wifi ", 2, "ddr4", "m-itx", "am4");
INSERT INTO motherboard (
    serial_number, name , ram_slots, ram_type, form_factor, socket) 
    VALUES ("U-M123456786", "Project X dual socket board", 8, "ddr4", "e-atx", "lga2066");

#Insert entries into the cpu table
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("R-C123456781", "Amd Ryzen 5 1600", "R-M123456781", 65, 6, "yes", "am4");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("R-C123456782", "Intel Core i5 3570k", "R-M123456782", 77, 4, "no", "lga1155");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("R-C123456783", "Intel Core i7 5820k", "R-M123456783", 140, 6, "yes", "lga2011v3");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("R-C123456784", "Amd Threadripper 3970X", "R-M123456784", 280 , 32, "yes", "tr4");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("R-C123456785", "Amd Ryzen 7 1800x", "R-M123456785", 95, 8, "yes", "am4");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("U-C123456786", "Cascade Lake-AP", "U-M123456786", 200, 64, "yes", "lga2066");
INSERT INTO central_processing_unit (
    serial_number, name, motherboard_sn, tdp, core_count, smt, socket)
    VALUES ("U-C123456787", "Cascade Lake-AP", "U-M123456786", 200, 64, "yes", "lga2066");


#Insert entries into the cpu cooler table
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("R-CC12345671", "Corsair h100i", "R-M123456781", 2200, 20, "am4");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("R-CC12345672", "Intel Stock Cooler", "R-M123456782", 1200, 30, "lga1155");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("R-CC12345673", "EK Supremecy Evo", "R-M123456783", 2200, 15, "lga2011v3");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("R-CC12345674", "Dual stack noctua cooler", "R-M123456784", 1800, 35, "tr4");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("R-CC12345675", "NZXT Kraken", "R-M123456785", 2200, 20, "am4");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("U-CC1234567x", "LN2 pt1", "U-M123456786", 1000, 5, "lga2066");
INSERT INTO cpu_cooler (
    serial_number, name, motherboard_sn, fan_rpm, noise_level, socket)
    VALUES ("U-CC1234567y", "LN2 pt2", "U-M123456786", 1000, 5, "lga2066");

    #Insert entries into the gpu table
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("R-G123456781", "Asus Geforce Gtx 970", "R-M123456781", 1114, 4, 280);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("R-G123456782", "Gigabyte Geforce Gtx 650ti", "R-M123456782", 928, 1, 144);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("R-G123456783", "Nvidia Quadro GV100", "R-M123456783", 1132, 32, 266);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("R-G123456784", "Amd Radeon VII", "R-M123456784", 1400, 16, 305);
INSERT INTO graphics_processing_unit (
    serial_number, name, motherboard_sn, core_clock, memory, gpu_length)
    VALUES ("R-G123456785", "Amd r9 290x", "R-M123456785", 1000, 4, 276);

#Insert entries into the psu table
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("R-P123456781", "Corsair cx600m", 600, "yes", "bronze", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("R-P123456782", "Evga br500", 500, "no", "bronze", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("R-P123456783", "Corsair rm850x", 850, "yes", "gold", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("R-P123456784", "Corsair ax1200i", 1200, "yes", "platinum", "atx");
INSERT INTO power_supply (
    serial_number, name, wattage, modular, efficiency_rating, form_factor)
    VALUES ("R-P123456785", "Silverstone SX600G", 600, "yes", "gold", "m-itx");

#Insert entries into the case table
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("R-CE12345671", "Fractal Design Define S", "R-M123456781", "R-P123456781", "400", "2.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("R-CE12345672", "Fractal Design Define R5", "R-M123456782", "R-P123456782", "310", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("R-CE12345673", "Zalman z11 plus", "R-M123456783", "R-P123456783", "290", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("R-CE12345674", "Nzxt h440", "R-M123456784", "R-P123456784", "294", "3.5inch");
INSERT INTO computer_case (
    serial_number, name, motherboard_sn, psu_sn, gpu_space, storage_bays)
    VALUES ("R-CE12345675", "Ncase M1", "R-M123456785", "R-P123456785", "280", "2.5inch");


#Insert entries into the storage table
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("R-S123456781", "Samsung 850 Evo", "R-CE12345671", 500, "sata", "2.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("R-S123456782", "Western Digital Caviar Green 1tb", "R-CE12345672", 1000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("R-S123456783", "Seagate Barracuda 2tb", "R-CE12345673", 2000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("R-S123456784", "Samsung HD105SI", "R-CE12345674", 1000, "sata", "3.5inch");
INSERT INTO storage_drive (
    serial_number, name, case_sn, capacity, interface, form_factor)
    VALUES ("R-S123456785", "Intel 730", "R-CE12345675", 240, "sata", "2.5inch");

#Insert entries into ram table
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R-R123456781", "Corsair Vengeance LPX", "R-M123456781", 16, 2, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R-R123456782", "G Skill Ripjaws", "R-M123456782", 8, 1, "ddr3");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R-R123456783", "Corsair Vengeance RGB", "R-M123456783", 16, 2, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R-R123456784", "Corsair Vengeance LPX", "R-M123456784", 128, 8, "ddr4");
INSERT INTO random_access_memory (
    serial_number, name, motherboard_sn, capacity, number_of_modules, type)
    VALUES ("R-R123456785", "Crucial Ballistix LT", "R-M123456785", 32, 2, "ddr4");

#Insert enties into the cooling table to link cpus and coolers together
INSERT INTO cooling (cpu_sn, cooler_sn)
    VALUES ("R-C123456781", "R-M123456781");
INSERT INTO cooling (cpu_sn, cooler_sn)
    VALUES ("R-C123456782", "R-M123456782");
INSERT INTO cooling (cpu_sn, cooler_sn)
    VALUES ("R-C123456783", "R-M123456783");
INSERT INTO cooling (cpu_sn, cooler_sn)
    VALUES ("R-C123456784", "R-M123456784");
INSERT INTO cooling (cpu_sn, cooler_sn)
    VALUES ("R-C123456785", "R-M123456785");