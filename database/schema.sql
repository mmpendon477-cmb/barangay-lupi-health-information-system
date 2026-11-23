-- BARANGAY LUPI COMMUNITY HEALTH INFORMATION MANAGEMENT SYSTEM (CHIMS)
-- DBMS: MySQL / Laragon

CREATE DATABASE IF NOT EXISTS barangay_lupi_chims
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE barangay_lupi_chims;

-- 1. APP_USER  (schema change: added role column for admin/staff access)
CREATE TABLE app_user (
    user_id BIGINT UNSIGNED AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    username VARCHAR(80) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin','staff') NOT NULL DEFAULT 'staff',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (user_id),
    UNIQUE (username)
) ENGINE=InnoDB;

-- 2. RESIDENT
CREATE TABLE resident (
    resident_id BIGINT UNSIGNED AUTO_INCREMENT,
    registered_by BIGINT UNSIGNED,
    household_code VARCHAR(50),
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    sex VARCHAR(30),
    contact_number VARCHAR(30),
    purok VARCHAR(80),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (resident_id),
    CONSTRAINT fk_resident_user FOREIGN KEY (registered_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. SENIOR_CITIZEN
CREATE TABLE senior_citizen (
    resident_id BIGINT UNSIGNED NOT NULL,
    senior_id_number VARCHAR(80) NOT NULL,
    registration_date DATE,
    status VARCHAR(40) NOT NULL,
    PRIMARY KEY (resident_id),
    UNIQUE (senior_id_number),
    CONSTRAINT fk_senior_resident FOREIGN KEY (resident_id)
        REFERENCES resident(resident_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. HEALTH_CONSULTATION
CREATE TABLE health_consultation (
    consultation_id BIGINT UNSIGNED AUTO_INCREMENT,
    resident_id BIGINT UNSIGNED NOT NULL,
    recorded_by BIGINT UNSIGNED NOT NULL,
    consultation_date DATETIME NOT NULL,
    diagnosis TEXT,
    notes TEXT,
    PRIMARY KEY (consultation_id),
    CONSTRAINT fk_consultation_resident FOREIGN KEY (resident_id)
        REFERENCES resident(resident_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_consultation_user FOREIGN KEY (recorded_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_consultation_resident_date (resident_id, consultation_date)
) ENGINE=InnoDB;

-- 5. HEALTH_PROGRAM
CREATE TABLE health_program (
    program_id BIGINT UNSIGNED AUTO_INCREMENT,
    created_by BIGINT UNSIGNED NOT NULL,
    title VARCHAR(180) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    location VARCHAR(180),
    status VARCHAR(40) NOT NULL,
    PRIMARY KEY (program_id),
    CONSTRAINT fk_program_user FOREIGN KEY (created_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_program_dates CHECK (end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

-- 6. ANNOUNCEMENT
CREATE TABLE announcement (
    announcement_id BIGINT UNSIGNED AUTO_INCREMENT,
    created_by BIGINT UNSIGNED NOT NULL,
    title VARCHAR(180) NOT NULL,
    body TEXT NOT NULL,
    publish_start DATETIME NOT NULL,
    publish_end DATETIME,
    status VARCHAR(40) NOT NULL,
    PRIMARY KEY (announcement_id),
    CONSTRAINT fk_announcement_user FOREIGN KEY (created_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_announcement_dates CHECK (publish_end IS NULL OR publish_end >= publish_start)
) ENGINE=InnoDB;

-- 7. HEALTH_CENTER_INFO
CREATE TABLE health_center_info (
    info_id BIGINT UNSIGNED AUTO_INCREMENT,
    updated_by BIGINT UNSIGNED NOT NULL,
    center_name VARCHAR(180) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_number VARCHAR(30),
    operating_hours VARCHAR(180),
    services TEXT,
    PRIMARY KEY (info_id),
    CONSTRAINT fk_center_user FOREIGN KEY (updated_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 8. MEDICINE
CREATE TABLE medicine (
    medicine_id BIGINT UNSIGNED AUTO_INCREMENT,
    generic_name VARCHAR(180) NOT NULL,
    brand_name VARCHAR(180),
    dosage_form VARCHAR(80),
    strength VARCHAR(80),
    requires_prescription BOOLEAN NOT NULL DEFAULT FALSE,
    reorder_level INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (medicine_id)
) ENGINE=InnoDB;

-- 9. MEDICINE_BATCH
CREATE TABLE medicine_batch (
    batch_id BIGINT UNSIGNED AUTO_INCREMENT,
    medicine_id BIGINT UNSIGNED NOT NULL,
    batch_code VARCHAR(100) NOT NULL,
    expiry_date DATE,
    quantity_on_hand INT NOT NULL DEFAULT 0,
    received_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (batch_id),
    UNIQUE (medicine_id, batch_code),
    CONSTRAINT fk_batch_medicine FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_batch_quantity CHECK (quantity_on_hand >= 0),
    INDEX idx_batch_expiry (expiry_date)
) ENGINE=InnoDB;

-- 10. MEDICINE_DISTRIBUTION
CREATE TABLE medicine_distribution (
    distribution_id BIGINT UNSIGNED AUTO_INCREMENT,
    resident_id BIGINT UNSIGNED NOT NULL,
    batch_id BIGINT UNSIGNED NOT NULL,
    recorded_by BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL,
    distributed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (distribution_id),
    CONSTRAINT fk_distribution_resident FOREIGN KEY (resident_id)
        REFERENCES resident(resident_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_distribution_batch FOREIGN KEY (batch_id)
        REFERENCES medicine_batch(batch_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_distribution_user FOREIGN KEY (recorded_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_distribution_quantity CHECK (quantity > 0),
    INDEX idx_distribution_resident_date (resident_id, distributed_at),
    INDEX idx_distribution_batch_date (batch_id, distributed_at)
) ENGINE=InnoDB;

-- 11. PRESCRIPTION_VERIFICATION
CREATE TABLE prescription_verification (
    verification_id BIGINT UNSIGNED AUTO_INCREMENT,
    distribution_id BIGINT UNSIGNED NOT NULL,
    checked_by BIGINT UNSIGNED NOT NULL,
    prescription_checked BOOLEAN NOT NULL,
    checked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reference_code VARCHAR(100),
    PRIMARY KEY (verification_id),
    UNIQUE (distribution_id),
    CONSTRAINT fk_verification_distribution FOREIGN KEY (distribution_id)
        REFERENCES medicine_distribution(distribution_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_verification_user FOREIGN KEY (checked_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 12. INVENTORY_TRANSACTION
CREATE TABLE inventory_transaction (
    transaction_id BIGINT UNSIGNED AUTO_INCREMENT,
    batch_id BIGINT UNSIGNED NOT NULL,
    recorded_by BIGINT UNSIGNED NOT NULL,
    distribution_id BIGINT UNSIGNED,
    transaction_type VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    PRIMARY KEY (transaction_id),
    UNIQUE (distribution_id),
    CONSTRAINT fk_transaction_batch FOREIGN KEY (batch_id)
        REFERENCES medicine_batch(batch_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_transaction_user FOREIGN KEY (recorded_by)
        REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_transaction_distribution FOREIGN KEY (distribution_id)
        REFERENCES medicine_distribution(distribution_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_transaction_quantity CHECK (quantity > 0),
    INDEX idx_transaction_batch_date (batch_id, transaction_date)
) ENGINE=InnoDB;
