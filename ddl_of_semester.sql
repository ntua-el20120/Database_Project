-- MySQL Script generated by MySQL Workbench
-- Mon May  1 21:21:13 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema semester_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema semester_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `semester_project` DEFAULT CHARACTER SET utf8 ;
USE `semester_project` ;

-- -----------------------------------------------------
-- Table `semester_project`.`Authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Authors` (
  `author_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`author_id`))
ENGINE = InnoDB
KEY_BLOCK_SIZE = 4;


-- -----------------------------------------------------
-- Table `semester_project`.`Belongs_in`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Belongs_in` (
  `category_id` INT NOT NULL,
  `book_ISBN` BIGINT(13) NOT NULL,
  PRIMARY KEY (`category_id`, `book_ISBN`),
  INDEX `fk_Thematic category_has_Book_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  INDEX `fk_Thematic category_has_Book_Thematic category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk__Belongs_in_Thematic_Category`
    FOREIGN KEY (`category_id`)
    REFERENCES `semester_project`.`Thematic_Category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Belongs_in_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Book` (
  `ISBN` BIGINT(13) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `publisher` VARCHAR(255) NOT NULL,
  `no_of_pages` INT NOT NULL,
  `summary` TEXT NULL,
  `image` BLOB(262144) NULL,
  `language` VARCHAR(255) NOT NULL DEFAULT 'English',
  PRIMARY KEY (`ISBN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Card`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Card` (
  `user_id` INT NOT NULL,
  `card_no` TINYINT NOT NULL,
  `status` ENUM("Pending", "Active", "Inactive", "Missing") NOT NULL DEFAULT "Pending",
  PRIMARY KEY (`user_id`, `card_no`),
  INDEX `fk_Card_Users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Card_Users_Id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Keywords`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Keywords` (
  `keyword_id` INT NOT NULL AUTO_INCREMENT,
  `keyword` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`keyword_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Keywords_in_book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Keywords_in_book` (
  `keyword_id` INT NOT NULL,
  `book_ISBN` BIGINT(13) NOT NULL,
  PRIMARY KEY (`keyword_id`, `book_ISBN`),
  INDEX `fk_Keywords_has_Book_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  INDEX `fk_Keywords_has_Book_Keywords1_idx` (`keyword_id` ASC) VISIBLE,
  CONSTRAINT `fk_Keywords_Keyword_id`
    FOREIGN KEY (`keyword_id`)
    REFERENCES `semester_project`.`Keywords` (`keyword_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk__Keywords_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Lib_Owns_Book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Lib_Owns_Book` (
  `book_ISBN` BIGINT(13) NOT NULL,
  `library_id` INT NOT NULL,
  `total_copies` SMALLINT NOT NULL,
  `available_copies` SMALLINT NOT NULL,
  PRIMARY KEY (`book_ISBN`, `library_id`),
  INDEX `fk_Book_has_School - Library_School - Library1_idx` (`library_id` ASC) VISIBLE,
  INDEX `fk_Book_has_School - Library_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `available_copies_number`
    CHECK (`available_copies` >= 0 and `available_copies` <= `total_copies`),
  CONSTRAINT `fk_Owns_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Owns_Library_id`
    FOREIGN KEY (`library_id`)
    REFERENCES `semester_project`.`School_Library` (`library_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Loan` (
  `book_ISBN` BIGINT(13) NOT NULL,
  `user_id` INT NOT NULL,
  `loan_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `return_date` DATE NULL,
  `status` ENUM("Active", "Late Active", "Returned", "Late Returned") NOT NULL DEFAULT "Active",
  PRIMARY KEY (`book_ISBN`, `user_id`),
  INDEX `fk_Book_has_Users_Users3_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_Book_has_Users_Book2_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_Loan_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Loan_User_Id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Operator_Appointment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Operator_Appointment` (
  `operator_id` INT NOT NULL,
  `library_appointment` INT NOT NULL,
  `administrator_id` INT NOT NULL,
  `appointment_no` INT NOT NULL,
  `date_of_appointment` DATE NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`operator_id`, `library_appointment`, `administrator_id`, `appointment_no`),
  INDEX `fk_Operator Appointment_School - Library1_idx` (`library_appointment` ASC) VISIBLE,
  INDEX `fk_Operator Appointment_Users2_idx` (`administrator_id` ASC) VISIBLE,
  CONSTRAINT `fk_OA_Operator`
    FOREIGN KEY (`operator_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OA_Library`
    FOREIGN KEY (`library_appointment`)
    REFERENCES `semester_project`.`School_Library` (`library_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OA_Admin`
    FOREIGN KEY (`administrator_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Pending_Registrations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Pending_Registrations` (
  `username` VARCHAR(255) NOT NULL,
  `password_hashed` TEXT NOT NULL,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `birth_date` DATE NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `user_role` ENUM('Admin', 'Operator', 'Teacher', 'Student') NOT NULL,
  `library_id` INT NOT NULL,
  PRIMARY KEY (`username`, `library_id`),
  INDEX `fk_Pending Registrations_School - Library1_idx` (`library_id` ASC) VISIBLE,
  CONSTRAINT `fk_Registration_Library_id`
    FOREIGN KEY (`library_id`)
    REFERENCES `semester_project`.`School_Library` (`library_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Reg_Phone_No`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Reg_Phone_No` (
  `number` BIGINT(20) NOT NULL,
  `registration_username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`number`, `registration_username`),
  INDEX `fk_Reg_ phone No_Registration1_idx` (`registration_username` ASC) VISIBLE,
  CONSTRAINT `fk_Reg_ phone No_Registration1`
    FOREIGN KEY (`registration_username`)
    REFERENCES `semester_project`.`Pending_Registrations` (`username`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Request` (
  `book_ISBN` BIGINT(13) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`book_ISBN`, `user_id`),
  INDEX `fk_Book_has_Users_Users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_Book_has_Users_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_Book_Requested`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Request_User_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Reservation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Reservation` (
  `book_ISBN` BIGINT(13) NOT NULL,
  `user_id` INT NOT NULL,
  `reservation_date` DATE NOT NULL,
  `expiration_date` DATE NOT NULL,
  `status` ENUM("Active", "Honoured", "Expired") NULL DEFAULT "Active",
  PRIMARY KEY (`book_ISBN`, `user_id`),
  INDEX `fk_Book_has_Users_Users2_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_Book_has_Users_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_Res_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Res_User_Id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Reviews` (
  `book_ISBN` BIGINT(13) NOT NULL,
  `user_id` INT NOT NULL,
  `likert_rating` TINYINT NOT NULL,
  `review` TEXT NULL,
  PRIMARY KEY (`book_ISBN`, `user_id`),
  INDEX `fk_Book_has_Users_Users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_Book_has_Users_Book_idx` (`book_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_Rev_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Rev_User_Id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`School_Library`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`School_Library` (
  `library_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `town` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `principals_id` INT NULL,
  PRIMARY KEY (`library_id`),
  INDEX `fk_School - Library_Users1_idx` (`principals_id` ASC) VISIBLE,
  CONSTRAINT `fk_Principal_id`
    FOREIGN KEY (`principals_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`School_Phone_No`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`School_Phone_No` (
  `phone_no` BIGINT(20) NOT NULL,
  `library_id` INT NOT NULL,
  PRIMARY KEY (`phone_no`, `library_id`),
  INDEX `fk_School_Phone_No_School - Library1_idx` (`library_id` ASC) VISIBLE,
  CONSTRAINT `fk_Phone_Library_id`
    FOREIGN KEY (`library_id`)
    REFERENCES `semester_project`.`School_Library` (`library_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Thematic_Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Thematic_Category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`User_Phone_No`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`User_Phone_No` (
  `number` BIGINT(20) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`number`, `user_id`),
  INDEX `fk_User_Phone_No_Users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Phone_User_Id`
    FOREIGN KEY (`user_id`)
    REFERENCES `semester_project`.`Users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `Password_Hashed` TEXT NOT NULL,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `birth_date` DATE NOT NULL,
  `email` VARCHAR(255) ,
  `last_update` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `user_role` ENUM('Admin', 'Operator', 'Teacher', 'Student') NOT NULL,
  `user_status` VARCHAR(255) NOT NULL,
  `users_library_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `Username_UNIQUE` (`username` ASC) VISIBLE,
  INDEX `fk_Users_School - Library1_idx` (`users_library_id` ASC) VISIBLE,
  UNIQUE INDEX `User_Id_UNIQUE` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_User_Library_id`
    FOREIGN KEY (`users_library_id`)
    REFERENCES `semester_project`.`School_Library` (`library_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `semester_project`.`Wrote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semester_project`.`Wrote` (
  `author_id` INT NOT NULL,
  `book_ISBN` BIGINT(13) NOT NULL,
  PRIMARY KEY (`author_id`, `book_ISBN`),
  INDEX `fk_Authors_has_Book_Book1_idx` (`book_ISBN` ASC) VISIBLE,
  INDEX `fk_Authors_has_Book_Authors1_idx` (`author_id` ASC) VISIBLE,
  CONSTRAINT `fk_Wrote_Author_id`
    FOREIGN KEY (`author_id`)
    REFERENCES `semester_project`.`Authors` (`author_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Wrote_Book_ISBN`
    FOREIGN KEY (`book_ISBN`)
    REFERENCES `semester_project`.`Book` (`ISBN`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- ----------------------------------------
-- Trigger for default value of available copies
-- ----------------------------------------

DELIMITER $
CREATE TRIGGER set_available_copies
BEFORE INSERT ON `semester_project`.`Lib_Owns_Book` 
FOR EACH ROW
BEGIN 
  IF NEW.`available_copies` IS NULL THEN
    SET NEW.`available_copies` = NEW.`total_copies`;
  END IF;
END $
DELIMITER ;


-- -----------------------------------------
-- Trigger for the default value of Card_no
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER set_card_no
BEFORE INSERT ON `semester_project`.`Card`
FOR EACH ROW
BEGIN
  IF NEW.`card_no` IS NULL THEN
    SET NEW.`card_no` = card_number(NEW.`user_id`);
  END IF;
END $
DELIMITER ;

-- -----------------------------------------
-- Trigger for inserting in to loans
-- If the book is in the library of the user
-- And if there are available copies
-- Then the loan will be inserted and if there is no return date the available copies will drop
-- If there is a return date I should also check if the status is correct
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER loan_integrty
BEFORE INSERT ON `semester_project`.`Loan`
FOR EACH ROW
BEGIN
  DECLARE avail_copies INT;
  DECLARE lib_id INT;

  SET avail_copies = ( 
    SELECT lob.`available_copies` 
    FROM `semester_project`.`Lib_Owns_Book` lob 
    INNER JOIN `semester_project`.`School_Library` s
    ON s.`library_id` = lob.`library_id`
    INNER JOIN `semester_project`.`Users` u
    ON s.`library_id` = u.`users_library_id`
    WHERE u.`user_id` = NEW.`user_id` and lob.`book_ISBN` = NEW.`book_ISBN`
  );
  IF FOUND_ROWS() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book does not exist in library of user';
  END IF;
  IF avail_copies = 0 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot borrow unavailable book';
  END IF;

  SET lib_id = (
    SELECT `users_library_id`
    FROM `semester_project`.`Users`
    WHERE `user_id` = NEW.`user_id`
  );
  IF NEW.`return_date` IS NOT NULL THEN
    UPDATE `semester_project`.`Lib_Owns_Book` SET `available_copies` = avail_copies-1 WHERE `book_ISBN` = NEW.`book_ISBN` and `library_id` = lib_id;
  END IF;
END $
DELIMITER ;

-- -----------------------------------------
-- Trigger for updating the status of the loan
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER loan_status
BEFORE UPDATE ON `semester_project`.`Loan`
FOR EACH ROW
BEGIN
  SET NEW.`loan_date` = OLD.`loan_date`;
  SET NEW.`book_ISBN` = OLD.`book_ISBN`;
  SET NEW.`user_id` = OLD.`user_id`;
  IF OLD.`return_date` IS NOT NULL THEN
    SET NEW.`return_date` = OLD.`return_date`;
    SET NEW.`status` = OLD.`status`;
  END IF;
  IF OLD.`return_date` IS NULL AND NEW.`return_date` IS NULL AND TIMESTAMPDIFF(DAY, OLD.`loan_date`, CURRENT_DATE()) > 14 THEN
    SET NEW.`status` = "Late Active";
  END IF;
  IF OLD.`return_date` IS NULL AND NEW.`return_date` IS NOT NULL AND TIMESTAMPDIFF(DAY, NEW.`loan_date`, NEW.`return_date`) > 14 THEN
    SET NEW.`status` = "Late Returned";
  END IF;
  IF OLD.`return_date` IS NULL AND NEW.`return_date` IS NOT NULL AND TIMESTAMPDIFF(DAY, NEW.`loan_date`, NEW.`return_date`) <= 14 THEN
    SET NEW.`status` = "Returned";
  END IF;
END $
DELIMITER ;

-- -----------------------------------------
-- Trigger for updating the status of the loan
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER reservation_status
BEFORE UPDATE ON `semester_project`.`Reservation`
FOR EACH ROW
BEGIN
  SET NEW.`book_ISBN` = OLD.`book_ISBN`;
  SET NEW.`user_id` = OLD.`user_id`;
  SET NEW.`reservation_date` = OLD.`reservation_date`;
  SET NEW.`expiration_date` = OLD.`expiration_date`;
  IF OLD.`status` = "Expired" OR OLD.`status` = "Honoured" THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: You cannot change an honoured or expired reservation';
  END IF;
  IF TIMESTAMPDIFF(DAY, NEW.`reservation_date`, CURRENT_DATE()) <= 7 THEN
    SET NEW.`status`= "Expired";
  END IF;
END $
DELIMITER ;

-- -----------------------------------------
-- Trigger to check the age before inserting data to users
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER check_age
BEFORE INSERT ON `semester_project`.`Users`
FOR EACH ROW
BEGIN
  IF ((NEW.`user_role` = 'Student' AND TIMESTAMPDIFF(YEAR,NEW.`birth_date`,NOW()) >= 18) OR (NEW.`user_role` <> 'Student' AND TIMESTAMPDIFF(YEAR,NEW.`birth_date`,NOW()) < 18 )) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = NEW.`birth_date`;
  END IF;
END $
DELIMITER ;


-- -----------------------------------------
-- Trigger to check the age before inserting data to users_reg
-- -----------------------------------------

DELIMITER $
CREATE TRIGGER check_age_reg
BEFORE INSERT ON `semester_project`.`Pending_Registrations`
FOR EACH ROW
BEGIN
  IF ((NEW.`user_role` = 'Student' AND TIMESTAMPDIFF(YEAR,NEW.`birth_date`,NOW()) >= 18) OR (NEW.`user_role` <> 'Student' AND TIMESTAMPDIFF(YEAR,NEW.`birth_date`,NOW()) < 18 )) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = NEW.`birth_date`;
  END IF;
END $
DELIMITER ;

-- -----------------------------------------
-- This is a function that finds the number of cards
-- a user has had so far and returns that plus one
-- -----------------------------------------

DELIMITER $
CREATE FUNCTION card_number (user_idd INT) RETURNS INT 
READS SQL DATA
BEGIN 
  DECLARE result INT;
  SELECT count(card_no)+1 INTO result FROM `Card` WHERE `user_id` = user_idd;
  RETURN result;
END $
DELIMITER ;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
