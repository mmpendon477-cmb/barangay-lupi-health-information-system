-- BARANGAY LUPI CHIMS: sample data (all records are fictional)
USE barangay_lupi_chims;

INSERT INTO app_user (user_id, full_name, username, password_hash, role, is_active) VALUES
(1, 'Maria Santos', 'msantos', 'sample_hash_001', 'admin', TRUE),
(2, 'Juan Reyes', 'jreyes', 'sample_hash_002', 'staff', TRUE),
(3, 'Ana Cruz', 'acruz', 'sample_hash_003', 'staff', TRUE);

INSERT INTO resident (resident_id, registered_by, household_code, full_name,
 birth_date, sex, contact_number, purok, is_active) VALUES
(1, 1, 'HH-001', 'Pedro Dela Cruz', '1955-04-12', 'Male', '09000000001', 'Purok 1', TRUE),
(2, 1, 'HH-002', 'Rosa Mendoza', '1960-08-20', 'Female', '09000000002', 'Purok 2', TRUE),
(3, 2, 'HH-003', 'Carlo Garcia', '1998-02-15', 'Male', '09000000003', 'Purok 3', TRUE),
(4, 2, 'HH-004', 'Liza Fernandez', '2001-11-05', 'Female', '09000000004', 'Purok 1', TRUE),
(5, 3, 'HH-005', 'Mario Bautista', '1972-06-30', 'Male', '09000000006', 'Purok 2', TRUE);

INSERT INTO senior_citizen (resident_id, senior_id_number, registration_date, status) VALUES
(1, 'SC-2026-001', '2026-01-10', 'Active'),
(2, 'SC-2026-002', '2026-02-15', 'Active');

INSERT INTO health_consultation (consultation_id, resident_id, recorded_by, consultation_date, diagnosis, notes) VALUES
(1, 1, 1, '2026-10-15', 'Hypertension', 'Routine blood pressure monitoring.'),
(2, 3, 2, '2026-10-20', 'Common cold', 'Advised rest and adequate fluid intake.'),
(3, 2, 1, '2026-10-25', 'Follow-up consultation', 'Routine health assessment.');

INSERT INTO health_program (program_id, created_by, title, description, start_date, end_date, location, status) VALUES
(1, 1, 'Community Medical Mission', 'Free basic health checkups for residents.',
 '2026-11-15', '2026-11-15', 'Barangay Lupi Health Center', 'Upcoming'),
(2, 2, 'Nutrition Awareness Program', 'Community education about proper nutrition.',
 '2026-11-20', '2026-11-20', 'Barangay Lupi Covered Court', 'Upcoming');

INSERT INTO announcement (announcement_id, created_by, title, body, publish_start, publish_end, status) VALUES
(1, 1, 'Health Center Schedule', 'The health center will provide regular services during posted operating hours.',
 '2026-11-01 08:00:00', '2026-11-30 17:00:00', 'Published'),
(2, 2, 'Upcoming Medical Mission', 'Residents are invited to participate in the community medical mission.',
 '2026-11-05 08:00:00', '2026-11-15 17:00:00', 'Published');

INSERT INTO health_center_info (info_id, updated_by, center_name, address, contact_number, operating_hours, services) VALUES
(1, 1, 'Barangay Lupi Health Center', 'Barangay Lupi, Tinambac, Camarines Sur',
 '09000000005', 'Monday-Friday, 8:00 AM-5:00 PM', 'Basic consultation, health monitoring, medicine distribution.');

INSERT INTO medicine (medicine_id, generic_name, brand_name, dosage_form, strength, requires_prescription, reorder_level) VALUES
(1, 'Paracetamol', 'Biogesic', 'Tablet', '500 mg', FALSE, 20),
(2, 'Amoxicillin', 'Amoxil', 'Capsule', '500 mg', TRUE, 15),
(3, 'Cetirizine', NULL, 'Tablet', '10 mg', FALSE, 10);

INSERT INTO medicine_batch (batch_id, medicine_id, batch_code, expiry_date, quantity_on_hand, received_at) VALUES
(1, 1, 'PAR-2026-001', '2027-12-31', 90, '2026-10-01'),
(2, 1, 'PAR-2026-002', '2028-06-30', 50, '2026-10-15'),
(3, 2, 'AMX-2026-001', '2027-09-30', 45, '2026-10-05'),
(4, 3, 'CET-2026-001', '2028-03-31', 75, '2026-10-10');

INSERT INTO medicine_distribution (distribution_id, resident_id, batch_id, recorded_by, quantity, distributed_at) VALUES
(1, 1, 1, 1, 10, '2026-10-20 09:30:00'),
(2, 3, 3, 2, 5, '2026-10-21 10:00:00');

INSERT INTO prescription_verification (verification_id, distribution_id, checked_by, prescription_checked, checked_at, reference_code) VALUES
(1, 2, 1, TRUE, '2026-10-21 09:55:00', 'RX-2026-001');

INSERT INTO inventory_transaction (transaction_id, batch_id, recorded_by, distribution_id, transaction_type, quantity, transaction_date, note) VALUES
(1, 1, 1, NULL, 'Stock In', 100, '2026-10-01 08:00:00', 'Initial medicine stock received.'),
(2, 1, 1, 1, 'Stock Out', 10, '2026-10-20 09:30:00', 'Medicine distributed to resident 1.'),
(3, 3, 2, NULL, 'Stock In', 50, '2026-10-05 08:00:00', 'Initial medicine stock received.'),
(4, 3, 2, 2, 'Stock Out', 5, '2026-10-21 10:00:00', 'Medicine distributed to resident 3.');
