CREATE TABLE Vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    fuel VARCHAR(20) NOT NULL,
    production_year YEAR,
    stk_valid_until DATE,
    seating_capacity INT,
    vin_code VARCHAR(50) NOT NULL,
    license_plate VARCHAR(20) NOT NULL,
    registration_number VARCHAR(50) NOT NULL,
    current_status VARCHAR(20)
);


CREATE TABLE Persons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    personal_number VARCHAR(20) NOT NULL
);


CREATE TABLE Reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    person_id INT NOT NULL,
    reservation_from DATETIME NOT NULL,
    reservation_to DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'ke schválení',
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles (id),
    FOREIGN KEY (person_id) REFERENCES Persons (id)
);


DELIMITER $$
CREATE TRIGGER check_vehicle_status BEFORE INSERT ON Reservations
FOR EACH ROW
BEGIN
    DECLARE vehicle_status VARCHAR(20);
    DECLARE stk_valid_until DATE;

    IF NEW.status = 'ke schválení' THEN
        -- Check if the vehicle is in operation
        SELECT current_status INTO vehicle_status FROM Vehicles WHERE id = NEW.vehicle_id;
        IF vehicle_status IS NULL OR vehicle_status <> 'v provozu' THEN
            SET NEW.status = 'zamítnuto';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vozidlo není k dispozici.';
        END IF;

       
        SELECT stk_valid_until INTO stk_valid_until FROM Vehicles WHERE id = NEW.vehicle_id;
        IF stk_valid_until IS NULL OR stk_valid_until < CURDATE() THEN
            SET NEW.status = 'zamítnuto';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Platnost STK vozidla vypršela.';
        END IF;
    END IF;
END$$
DELIMITER ;
