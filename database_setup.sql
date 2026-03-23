-- ============================================
-- SHIPMENT SLA RISK TRACKING SYSTEM
-- Database: PostgreSQL via Supabase
-- ============================================

-- TABLE 1: Shipments
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    origin_city TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    carrier_name TEXT NOT NULL,
    shipment_date DATE NOT NULL,
    promised_delivery_date DATE NOT NULL,
    current_status TEXT NOT NULL CHECK (current_status IN ('In Transit', 'Out for Delivery', 'Delayed', 'Delivered')),
    last_update_date DATE NOT NULL,
    shipment_value NUMERIC(10,2) NOT NULL
);

-- TABLE 2: SLA Rules
CREATE TABLE sla_rules (
    rule_id SERIAL PRIMARY KEY,
    origin_city TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    carrier_name TEXT NOT NULL,
    standard_transit_days INT NOT NULL,
    max_allowed_days INT NOT NULL
);

-- TABLE 3: Shipment Risk Scores
CREATE TABLE shipment_risk_scores (
    score_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES shipments(shipment_id),
    days_in_transit INT NOT NULL,
    days_until_deadline INT NOT NULL,
    delay_flag BOOLEAN NOT NULL,
    risk_score NUMERIC(5,2) NOT NULL,
    risk_level TEXT NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Breached')),
    score_date DATE NOT NULL
);

-- TABLE 4: Alert Log
CREATE TABLE alert_log (
    alert_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES shipments(shipment_id),
    alert_type TEXT NOT NULL CHECK (alert_type IN ('High Risk Warning', 'SLA Breached')),
    alert_sent_at TIMESTAMP DEFAULT NOW(),
    recipient_email TEXT NOT NULL
);

-- ============================================
-- SEED DATA
-- ============================================

INSERT INTO sla_rules (origin_city, destination_city, carrier_name, standard_transit_days, max_allowed_days) VALUES
('Lagos', 'Abuja', 'SwiftMove Logistics', 2, 4),
('Lagos', 'Abuja', 'RedStar Express', 2, 4),
('Lagos', 'Port Harcourt', 'SwiftMove Logistics', 3, 5),
('Lagos', 'Kano', 'DHL Nigeria', 3, 5),
('Lagos', 'Kano', 'SwiftMove Logistics', 3, 6),
('Abuja', 'Lagos', 'RedStar Express', 2, 4),
('Abuja', 'Kano', 'DHL Nigeria', 2, 3),
('Abuja', 'Port Harcourt', 'SwiftMove Logistics', 4, 6),
('Port Harcourt', 'Lagos', 'DHL Nigeria', 3, 5),
('Kano', 'Lagos', 'RedStar Express', 4, 6);

INSERT INTO shipments (customer_name, origin_city, destination_city, carrier_name, shipment_date, promised_delivery_date, current_status, last_update_date, shipment_value) VALUES
('Dangote Industries', 'Lagos', 'Abuja', 'SwiftMove Logistics', '2026-03-20', '2026-03-25', 'In Transit', '2026-03-21', 85000.00),
('Konga Online Store', 'Abuja', 'Lagos', 'RedStar Express', '2026-03-21', '2026-03-26', 'In Transit', '2026-03-21', 42000.00),
('Jumia Nigeria', 'Lagos', 'Port Harcourt', 'SwiftMove Logistics', '2026-03-20', '2026-03-27', 'In Transit', '2026-03-20', 63000.00),
('MTN Nigeria', 'Kano', 'Lagos', 'RedStar Express', '2026-03-21', '2026-03-28', 'In Transit', '2026-03-21', 120000.00),
('Access Bank', 'Abuja', 'Port Harcourt', 'SwiftMove Logistics', '2026-03-19', '2026-03-27', 'In Transit', '2026-03-20', 95000.00),
('Flour Mills Nigeria', 'Lagos', 'Kano', 'DHL Nigeria', '2026-03-17', '2026-03-23', 'In Transit', '2026-03-20', 210000.00),
('Nestle Nigeria', 'Abuja', 'Kano', 'DHL Nigeria', '2026-03-18', '2026-03-23', 'In Transit', '2026-03-20', 175000.00),
('GT Bank', 'Port Harcourt', 'Lagos', 'DHL Nigeria', '2026-03-17', '2026-03-24', 'Out for Delivery', '2026-03-21', 88000.00),
('PZ Cussons', 'Lagos', 'Abuja', 'RedStar Express', '2026-03-18', '2026-03-23', 'In Transit', '2026-03-19', 54000.00),
('Unilever Nigeria', 'Kano', 'Lagos', 'RedStar Express', '2026-03-16', '2026-03-24', 'In Transit', '2026-03-20', 143000.00),
('Zenith Bank', 'Lagos', 'Kano', 'SwiftMove Logistics', '2026-03-15', '2026-03-22', 'Delayed', '2026-03-19', 320000.00),
('Total Energies', 'Abuja', 'Lagos', 'RedStar Express', '2026-03-17', '2026-03-22', 'Delayed', '2026-03-20', 275000.00),
('Shoprite Nigeria', 'Lagos', 'Port Harcourt', 'SwiftMove Logistics', '2026-03-15', '2026-03-22', 'In Transit', '2026-03-18', 198000.00),
('Honeywell Group', 'Lagos', 'Abuja', 'SwiftMove Logistics', '2026-03-17', '2026-03-22', 'Delayed', '2026-03-20', 162000.00),
('Seplat Energy', 'Port Harcourt', 'Lagos', 'DHL Nigeria', '2026-03-14', '2026-03-22', 'Delayed', '2026-03-19', 410000.00),
('Nigerian Breweries', 'Lagos', 'Kano', 'DHL Nigeria', '2026-03-10', '2026-03-16', 'Delayed', '2026-03-18', 530000.00),
('Lafarge Africa', 'Abuja', 'Port Harcourt', 'SwiftMove Logistics', '2026-03-09', '2026-03-15', 'Delayed', '2026-03-17', 890000.00),
('Julius Berger', 'Kano', 'Lagos', 'RedStar Express', '2026-03-08', '2026-03-14', 'Delayed', '2026-03-16', 1250000.00),
('Oando Energy', 'Lagos', 'Abuja', 'RedStar Express', '2026-03-11', '2026-03-17', 'Delayed', '2026-03-18', 675000.00),
('BUA Foods', 'Port Harcourt', 'Lagos', 'DHL Nigeria', '2026-03-07', '2026-03-13', 'Delayed', '2026-03-15', 945000.00);

-- ============================================
-- DASHBOARD VIEW
-- ============================================

CREATE OR REPLACE VIEW shipment_dashboard_view AS
SELECT
  s.shipment_id,
  s.customer_name,
  s.origin_city,
  s.destination_city,
  s.carrier_name,
  s.shipment_date,
  s.promised_delivery_date,
  s.current_status,
  s.shipment_value,
  r.risk_score,
  r.risk_level,
  r.days_in_transit,
  r.days_until_deadline,
  r.delay_flag,
  r.score_date
FROM shipments s
LEFT JOIN shipment_risk_scores r
  ON s.shipment_id = r.shipment_id;
