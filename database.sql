CREATE DATABASE IF NOT EXISTS oman_case_guardian CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oman_case_guardian;

CREATE TABLE users(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(150) NOT NULL,email VARCHAR(190) UNIQUE,
 password_hash VARCHAR(255),role ENUM('owner','admin','editor','viewer') DEFAULT 'owner',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE cases(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_no VARCHAR(80) UNIQUE NOT NULL,title VARCHAR(255) NOT NULL,
 language ENUM('en','bn','ar') DEFAULT 'en',status ENUM('open','monitoring','submitted','closed') DEFAULT 'open',
 risk ENUM('low','medium','high','critical') DEFAULT 'medium',description TEXT,next_deadline DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);

CREATE TABLE parties(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NOT NULL,
 party_type ENUM('worker','employer','authority','witness','other') NOT NULL,name VARCHAR(255) NOT NULL,
 notes TEXT,FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE);

CREATE TABLE documents(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NOT NULL,
 original_name VARCHAR(255) NOT NULL,stored_path VARCHAR(600) NOT NULL,mime_type VARCHAR(180),
 extension VARCHAR(20),file_size BIGINT UNSIGNED DEFAULT 0,sha256 CHAR(64) NOT NULL,
 source ENUM('upload','google_drive','web','email') DEFAULT 'upload',
 extracted_text LONGTEXT,extraction_status ENUM('pending','complete','unsupported','failed') DEFAULT 'pending',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE,INDEX(sha256));

CREATE TABLE legal_sources(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,title VARCHAR(255) NOT NULL,
 source_type ENUM('royal_decree','law','ministerial_decision','official_page','judgment','secondary') NOT NULL,
 citation VARCHAR(255),url VARCHAR(1200),version_date DATE,verified_official BOOLEAN DEFAULT FALSE,
 content_hash CHAR(64),notes TEXT,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE rules(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,code VARCHAR(80) UNIQUE NOT NULL,title VARCHAR(255) NOT NULL,
 description TEXT,source_id BIGINT UNSIGNED NULL,article_ref VARCHAR(100),version_date DATE,
 active BOOLEAN DEFAULT TRUE,FOREIGN KEY(source_id) REFERENCES legal_sources(id) ON DELETE SET NULL);

CREATE TABLE findings(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NOT NULL,document_id BIGINT UNSIGNED NULL,
 rule_id BIGINT UNSIGNED NULL,severity ENUM('info','warning','high','critical') DEFAULT 'info',
 title VARCHAR(255) NOT NULL,analysis TEXT NOT NULL,evidence_quote TEXT,confidence DECIMAL(5,2) DEFAULT 0,
 recommendation TEXT,status ENUM('open','reviewed','dismissed') DEFAULT 'open',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE,
 FOREIGN KEY(document_id) REFERENCES documents(id) ON DELETE SET NULL,
 FOREIGN KEY(rule_id) REFERENCES rules(id) ON DELETE SET NULL);

CREATE TABLE timeline(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NOT NULL,event_date DATETIME NOT NULL,
 event_type VARCHAR(80),title VARCHAR(255) NOT NULL,details TEXT,document_id BIGINT UNSIGNED NULL,
 FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE);

CREATE TABLE evidence_links(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NOT NULL,claim VARCHAR(500) NOT NULL,
 document_id BIGINT UNSIGNED NULL,source_id BIGINT UNSIGNED NULL,status ENUM('supported','partial','missing','contradictory') DEFAULT 'missing',
 note TEXT,FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE,
 FOREIGN KEY(document_id) REFERENCES documents(id) ON DELETE SET NULL,
 FOREIGN KEY(source_id) REFERENCES legal_sources(id) ON DELETE SET NULL);

CREATE TABLE alerts(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,case_id BIGINT UNSIGNED NULL,
 type ENUM('deadline','missing_evidence','rule_change','research','system') NOT NULL,
 severity ENUM('info','warning','high','critical') DEFAULT 'warning',message TEXT NOT NULL,
 due_at DATETIME NULL,is_read BOOLEAN DEFAULT FALSE,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(case_id) REFERENCES cases(id) ON DELETE CASCADE);

CREATE TABLE audit_log(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,user_id BIGINT UNSIGNED NULL,action VARCHAR(120) NOT NULL,
 entity_type VARCHAR(80),entity_id BIGINT UNSIGNED,ip_hash CHAR(64),details JSON,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

INSERT INTO legal_sources(title,source_type,citation,url,version_date,verified_official,notes) VALUES
('Oman Labour Law — Royal Decree 53/2023','royal_decree','Royal Decree 53/2023','https://www.mol.gov.om/Laborlaw?lid=102','2023-07-25',1,'Official Ministry Labour Law portal. Re-check amendments.'),
('Wage Protection System — Rules','official_page','Ministerial Decision 299/2023','https://www.mol.gov.om/pages/Wps-Rules',NULL,1,'Official Ministry WPS rules.'),
('Wage Protection System — Overview','official_page','Ministry of Labour WPS','https://www.mol.gov.om/pages/ABOUT-WPS',NULL,1,'Official WPS overview and wage evidence guidance.'),
('Ministry Labour Complaints','official_page','Labour complaints service','https://www.mol.gov.om/',NULL,1,'Use current Ministry e-service instructions.'),
('Work Permit Regulation','ministerial_decision','Ministerial Decision 602/2025','https://www.mol.gov.om/MinisterialDecision','2025-01-01',1,'Verify current consolidated text and amendments on official portal.'),
('Amendment to 602/2025','ministerial_decision','Ministerial Decision 44/2026','https://www.mol.gov.om/MinisterialDecision','2026-01-01',1,'Official Ministry decision index; verify displayed consolidated text.');

INSERT INTO rules(code,title,description,source_id,article_ref,version_date) VALUES
('R-001','Contract / actual-work mismatch','Compare written contract, work permit profession and documented actual duties.',1,'Article 53','2023-07-25'),
('R-002','Passport / document retention indicator','Flag evidence suggesting prohibited retention of worker documents without lawful basis/consent.',1,'Article 6','2023-07-25'),
('R-003','Forced-work indicator','Flag evidence suggesting forced or compulsory work.',1,'Article 5','2023-07-25'),
('R-004','Wage reconciliation','Compare contractual wage, bank credits, WPS/payroll evidence and lawful deductions.',3,'Article 87','2023-07-25'),
('R-005','Work-permit profession mismatch','Compare work-permit profession, contract and actual duties against current licensing rules.',5,NULL,'2025-01-01'),
('R-006','Evidence-chain gap','Every material allegation needs date, source, original evidence and relationship to claim.',NULL,NULL,NULL);
