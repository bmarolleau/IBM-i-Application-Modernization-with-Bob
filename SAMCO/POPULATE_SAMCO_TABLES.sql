-- ============================================================================
-- SAMCO Library - Sample Data Population Script
-- ============================================================================
-- This script populates all tables in the SAMCO library with sample data
-- for testing the Article Management Web Application
--
-- Execute this script using:
--   RUNSQLSTM SRCFILE(QSQLSRC) SRCMBR(POPULATE) COMMIT(*NONE) NAMING(*SQL)
--
-- Or run via ACS Run SQL Scripts
-- ============================================================================

-- Clear existing data (optional - comment out if you want to keep existing data)
-- DELETE FROM SAMCO.ARTIPROV;
-- DELETE FROM SAMCO.DETORD;
-- DELETE FROM SAMCO.ORDER;
-- DELETE FROM SAMCO.ARTICLE;
-- DELETE FROM SAMCO.CUSTOMER;
-- DELETE FROM SAMCO.PROVIDER;
-- DELETE FROM SAMCO.FAMILLY;
-- DELETE FROM SAMCO.COUNTRY;
-- DELETE FROM SAMCO.PARAMETER WHERE PACODE = 'VAT';

-- ============================================================================
-- 1. COUNTRY Table - Country codes and names
-- ============================================================================
INSERT INTO SAMCO.COUNTRY (COID, COUNTR, COISO, COISO5, COISO1) VALUES
('FR', 'France', 'FRA', '250', '33'),
('US', 'United States', 'USA', '840', '1'),
('GB', 'United Kingdom', 'GBR', '826', '44'),
('DE', 'Germany', 'DEU', '276', '49'),
('ES', 'Spain', 'ESP', '724', '34'),
('IT', 'Italy', 'ITA', '380', '39'),
('BE', 'Belgium', 'BEL', '056', '32'),
('NL', 'Netherlands', 'NLD', '528', '31'),
('CH', 'Switzerland', 'CHE', '756', '41'),
('CA', 'Canada', 'CAN', '124', '1');

-- ============================================================================
-- 2. FAMILLY Table - Product families/categories
-- ============================================================================
INSERT INTO SAMCO.FAMILLY (FAID, FADESC, FAVATCD, FACREA, FAMOD, FAMODID, FADEL) VALUES
('ELE', 'Electronics', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('FUR', 'Furniture', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('CLO', 'Clothing', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('BOO', 'Books', '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('TOY', 'Toys', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('SPO', 'Sports Equipment', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('GAR', 'Garden', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('FOO', 'Food', '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('HOM', 'Home Appliances', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('OFF', 'Office Supplies', '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', '');

-- ============================================================================
-- 3. ARTICLE Table - Products/Articles
-- ============================================================================
INSERT INTO SAMCO.ARTICLE (ARID, ARDESC, ARSALEPR, ARWHSPR, ARTIFA, ARSTOCK, ARMINQTY, ARCUSQTY, ARPURQTY, ARVATCD, ARCREA, ARMOD, ARMODID, ARDEL) VALUES
-- Electronics
('000001', 'Laptop Computer 15 inch', 899.99, 650.00, 'ELE', 25, 5, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000002', 'Wireless Mouse', 29.99, 15.00, 'ELE', 150, 20, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000003', 'USB-C Cable 2m', 12.99, 5.00, 'ELE', 200, 50, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000004', 'Bluetooth Headphones', 79.99, 45.00, 'ELE', 80, 10, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000005', 'Smartphone 128GB', 599.99, 420.00, 'ELE', 40, 8, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Furniture
('000010', 'Office Chair Ergonomic', 249.99, 150.00, 'FUR', 30, 5, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000011', 'Desk 120x60cm White', 189.99, 110.00, 'FUR', 20, 3, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000012', 'Bookshelf 5 Shelves', 129.99, 75.00, 'FUR', 15, 2, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000013', 'Coffee Table Modern', 159.99, 90.00, 'FUR', 12, 2, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Clothing
('000020', 'T-Shirt Cotton Blue M', 19.99, 8.00, 'CLO', 100, 20, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000021', 'Jeans Denim Black 32', 49.99, 25.00, 'CLO', 75, 15, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000022', 'Jacket Winter XL', 89.99, 50.00, 'CLO', 40, 8, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Books
('000030', 'Programming Guide 2024', 39.99, 20.00, 'BOO', 60, 10, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000031', 'Business Management Handbook', 45.99, 25.00, 'BOO', 45, 8, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000032', 'Fiction Novel Bestseller', 24.99, 12.00, 'BOO', 80, 15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Toys
('000040', 'Building Blocks Set 500pcs', 34.99, 18.00, 'TOY', 90, 15, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000041', 'Remote Control Car', 59.99, 35.00, 'TOY', 50, 10, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000042', 'Board Game Family Edition', 29.99, 15.00, 'TOY', 70, 12, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Sports Equipment
('000050', 'Yoga Mat Premium', 39.99, 20.00, 'SPO', 60, 10, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000051', 'Dumbbell Set 20kg', 79.99, 45.00, 'SPO', 35, 5, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000052', 'Tennis Racket Professional', 129.99, 75.00, 'SPO', 25, 5, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Garden
('000060', 'Garden Hose 25m', 44.99, 25.00, 'GAR', 40, 8, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000061', 'Plant Pot Ceramic Large', 29.99, 15.00, 'GAR', 80, 15, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000062', 'Garden Tool Set 5pcs', 54.99, 30.00, 'GAR', 45, 8, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Food
('000070', 'Organic Coffee Beans 1kg', 24.99, 12.00, 'FOO', 120, 20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000071', 'Premium Tea Selection Box', 19.99, 10.00, 'FOO', 100, 15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000072', 'Chocolate Gift Box Assorted', 34.99, 18.00, 'FOO', 85, 15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Home Appliances
('000080', 'Vacuum Cleaner Cordless', 199.99, 120.00, 'HOM', 30, 5, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000081', 'Coffee Maker Automatic', 89.99, 50.00, 'HOM', 45, 8, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000082', 'Microwave Oven 800W', 129.99, 75.00, 'HOM', 35, 6, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Office Supplies
('000090', 'Printer Paper A4 500 sheets', 9.99, 5.00, 'OFF', 200, 40, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000091', 'Pen Set Ballpoint 10pcs', 7.99, 3.50, 'OFF', 250, 50, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000092', 'Notebook A5 Ruled 200 pages', 5.99, 2.50, 'OFF', 300, 60, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', '');

-- ============================================================================
-- 4. PROVIDER Table - Suppliers
-- ============================================================================
INSERT INTO SAMCO.PROVIDER (PRID, PROVNM, PRCONT, PRPHONE, PRVAT, PRMAIL, PRLINE1, PRLINE2, PRLINE3, PRZIP, PRCITY, PRCOUN, PRCREA, PRMOD, PRMODID, PRDEL) VALUES
(1, 'TechSupply International', 'John Smith', '+33123456789', 'FR1234567890', 'contact@techsupply.com', '123 Tech Avenue', 'Building A', '', '75001', 'Paris', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(2, 'Furniture World Ltd', 'Marie Dubois', '+33198765432', 'FR9876543210', 'sales@furnitureworld.com', '456 Design Street', '', '', '69001', 'Lyon', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(3, 'Fashion Imports SA', 'Pierre Martin', '+33145678901', 'FR4567890123', 'info@fashionimports.com', '789 Style Boulevard', 'Floor 3', '', '13001', 'Marseille', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(4, 'Book Distributors Inc', 'Sophie Laurent', '+33167890123', 'FR6789012345', 'orders@bookdist.com', '321 Literature Lane', '', '', '33000', 'Bordeaux', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(5, 'Toy Warehouse Europe', 'Luc Bernard', '+33189012345', 'FR8901234567', 'contact@toywarehouse.eu', '654 Play Street', '', '', '31000', 'Toulouse', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(6, 'Sports Equipment Pro', 'Emma Rousseau', '+33112345678', 'FR1234567802', 'sales@sportspro.com', '987 Athletic Road', '', '', '44000', 'Nantes', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(7, 'Garden Supplies Direct', 'Thomas Petit', '+33134567890', 'FR3456789012', 'info@gardensupplies.fr', '147 Green Avenue', '', '', '67000', 'Strasbourg', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(8, 'Gourmet Food Imports', 'Claire Moreau', '+33156789012', 'FR5678901234', 'orders@gourmetfood.com', '258 Taste Boulevard', '', '', '59000', 'Lille', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(9, 'Home Appliance Whsl', 'Marc Simon', '+33178901234', 'FR7890123456', 'contact@homeappliance.fr', '369 Comfort Street', '', '', '35000', 'Rennes', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(10, 'Office Solutions Group', 'Julie Leroy', '+33190123456', 'FR9012345678', 'sales@officesolutions.com', '741 Business Park', '', '', '21000', 'Dijon', 'FR', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', '');

-- ============================================================================
-- 5. CUSTOMER Table - Customers
-- ============================================================================
INSERT INTO SAMCO.CUSTOMER (CUID, CUSTNM, CUPHONE, CUVAT, CUMAIL, CULINE1, CULINE2, CULINE3, CUZIP, CUCITY, CUCOUN, CULIMCRE, CUCREDIT, CULASTORD, CUCREA, CUMOD, CUMODID, CUDEL) VALUES
(1, 'Acme Corporation', '+33140000001', 'FR1111111111', 'orders@acme.com', '100 Business Street', '', '', '75008', 'Paris', 'FR', 50000.00, 45000.00, 20260115, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(2, 'Global Trading SA', '+33140000002', 'FR2222222222', 'contact@globaltrading.fr', '200 Commerce Avenue', '', '', '69002', 'Lyon', 'FR', 75000.00, 70000.00, 20260110, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(3, 'Tech Solutions Ltd', '+33140000003', 'FR3333333333', 'info@techsolutions.com', '300 Innovation Road', '', '', '13002', 'Marseille', 'FR', 100000.00, 85000.00, 20260118, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(4, 'Retail Masters Inc', '+33140000004', 'FR4444444444', 'sales@retailmasters.fr', '400 Shopping Boulevard', '', '', '33001', 'Bordeaux', 'FR', 60000.00, 55000.00, 20260112, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(5, 'Distribution Plus', '+33140000005', 'FR5555555555', 'orders@distplus.com', '500 Logistics Lane', '', '', '31001', 'Toulouse', 'FR', 80000.00, 72000.00, 20260116, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(6, 'Enterprise Systems', '+33140000006', 'FR6666666666', 'contact@entsystems.fr', '600 Corporate Drive', '', '', '44001', 'Nantes', 'FR', 90000.00, 80000.00, 20260114, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(7, 'Quality Goods SARL', '+33140000007', 'FR7777777777', 'info@qualitygoods.com', '700 Quality Street', '', '', '67001', 'Strasbourg', 'FR', 55000.00, 50000.00, 20260111, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(8, 'Premium Buyers Group', '+33140000008', 'FR8888888888', 'orders@premiumbuyers.fr', '800 Luxury Avenue', '', '', '59001', 'Lille', 'FR', 120000.00, 100000.00, 20260117, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(9, 'Smart Commerce', '+33140000009', 'FR9999999999', 'sales@smartcommerce.com', '900 Digital Plaza', '', '', '35001', 'Rennes', 'FR', 70000.00, 65000.00, 20260113, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
(10, 'Value Partners SA', '+33140000010', 'FR1010101010', 'contact@valuepartners.fr', '1000 Partnership Way', '', '', '21001', 'Dijon', 'FR', 65000.00, 60000.00, 20260109, CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', '');

-- ============================================================================
-- 6. ORDER Table - Customer Orders
-- ============================================================================
INSERT INTO SAMCO.ORDER (ORID, ORYEAR, ORCUID, ORDATE, ORDATDEL, ORDATCLO) VALUES
(1, 2026, 1, 20260115, 20260122, 0),
(2, 2026, 2, 20260110, 20260117, 20260117),
(3, 2026, 3, 20260118, 20260125, 0),
(4, 2026, 4, 20260112, 20260119, 0),
(5, 2026, 5, 20260116, 20260123, 0),
(6, 2026, 6, 20260114, 20260121, 0),
(7, 2026, 7, 20260111, 20260118, 20260118),
(8, 2026, 8, 20260117, 20260124, 0),
(9, 2026, 9, 20260113, 20260120, 0),
(10, 2026, 10, 20260109, 20260116, 20260116);

-- ============================================================================
-- 7. DETORD Table - Order Details/Lines
-- ============================================================================
INSERT INTO SAMCO.DETORD (ODORID, ODYEAR, ODLINE, ODARID, ODQTY, ODQTYLIV, ODPRICE, ODTOT, ODTOTVAT) VALUES
-- Order 1 (Customer 1)
(1, 2026, 1, '000001', 2, 0, 899.99, 1799.98, 2159.98),
(1, 2026, 2, '000002', 5, 0, 29.99, 149.95, 179.94),
(1, 2026, 3, '000010', 3, 0, 249.99, 749.97, 899.96),

-- Order 2 (Customer 2) - Delivered
(2, 2026, 1, '000020', 50, 50, 19.99, 999.50, 1199.40),
(2, 2026, 2, '000021', 30, 30, 49.99, 1499.70, 1799.64),

-- Order 3 (Customer 3)
(3, 2026, 1, '000005', 10, 0, 599.99, 5999.90, 7199.88),
(3, 2026, 2, '000004', 15, 0, 79.99, 1199.85, 1439.82),

-- Order 4 (Customer 4)
(4, 2026, 1, '000030', 20, 0, 39.99, 799.80, 879.78),
(4, 2026, 2, '000031', 15, 0, 45.99, 689.85, 758.84),
(4, 2026, 3, '000032', 25, 0, 24.99, 624.75, 687.23),

-- Order 5 (Customer 5)
(5, 2026, 1, '000040', 40, 0, 34.99, 1399.60, 1679.52),
(5, 2026, 2, '000041', 20, 0, 59.99, 1199.80, 1439.76),

-- Order 6 (Customer 6)
(6, 2026, 1, '000080', 8, 0, 199.99, 1599.92, 1919.90),
(6, 2026, 2, '000081', 12, 0, 89.99, 1079.88, 1295.86),

-- Order 7 (Customer 7) - Delivered
(7, 2026, 1, '000090', 100, 100, 9.99, 999.00, 1198.80),
(7, 2026, 2, '000091', 80, 80, 7.99, 639.20, 767.04),

-- Order 8 (Customer 8)
(8, 2026, 1, '000011', 5, 0, 189.99, 949.95, 1139.94),
(8, 2026, 2, '000012', 8, 0, 129.99, 1039.92, 1247.90),

-- Order 9 (Customer 9)
(9, 2026, 1, '000050', 25, 0, 39.99, 999.75, 1199.70),
(9, 2026, 2, '000051', 15, 0, 79.99, 1199.85, 1439.82),

-- Order 10 (Customer 10) - Delivered
(10, 2026, 1, '000070', 60, 60, 24.99, 1499.40, 1649.34),
(10, 2026, 2, '000071', 50, 50, 19.99, 999.50, 1099.45);

-- ============================================================================
-- 8. ARTIPROV Table - Article-Provider relationships
-- ============================================================================
INSERT INTO SAMCO.ARTIPROV (APARID, APPRID, APPRICE, APREF, APCREA, APMOD, APMODID, APDEL) VALUES
-- Electronics from TechSupply
('000001', 1, 650.00, 'TS-LAP-001', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000002', 1, 15.00, 'TS-MOU-002', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000003', 1, 5.00, 'TS-CAB-003', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000004', 1, 45.00, 'TS-HEA-004', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000005', 1, 420.00, 'TS-PHO-005', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Furniture from Furniture World
('000010', 2, 150.00, 'FW-CHA-010', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000011', 2, 110.00, 'FW-DES-011', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000012', 2, 75.00, 'FW-BOO-012', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000013', 2, 90.00, 'FW-COF-013', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Clothing from Fashion Imports
('000020', 3, 8.00, 'FI-TSH-020', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000021', 3, 25.00, 'FI-JEA-021', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000022', 3, 50.00, 'FI-JAC-022', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Books from Book Distributors
('000030', 4, 20.00, 'BD-PRO-030', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000031', 4, 25.00, 'BD-BUS-031', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000032', 4, 12.00, 'BD-FIC-032', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Toys from Toy Warehouse
('000040', 5, 18.00, 'TW-BLO-040', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000041', 5, 35.00, 'TW-CAR-041', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000042', 5, 15.00, 'TW-BOA-042', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Sports from Sports Equipment Pro
('000050', 6, 20.00, 'SE-YOG-050', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000051', 6, 45.00, 'SE-DUM-051', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000052', 6, 75.00, 'SE-TEN-052', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Garden from Garden Supplies
('000060', 7, 25.00, 'GS-HOS-060', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000061', 7, 15.00, 'GS-POT-061', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000062', 7, 30.00, 'GS-TOO-062', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Food from Gourmet Food
('000070', 8, 12.00, 'GF-COF-070', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000071', 8, 10.00, 'GF-TEA-071', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000072', 8, 18.00, 'GF-CHO-072', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Home Appliances from Home Appliance Wholesale
('000080', 9, 120.00, 'HA-VAC-080', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000081', 9, 50.00, 'HA-COF-081', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000082', 9, 75.00, 'HA-MIC-082', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),

-- Office from Office Solutions
('000090', 10, 5.00, 'OS-PAP-090', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000091', 10, 3.50, 'OS-PEN-091', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ''),
('000092', 10, 2.50, 'OS-NOT-092', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', '');

-- ============================================================================
-- 9. PARAMETER Table - Application parameters
-- ============================================================================
INSERT INTO SAMCO.PARAMETER (PACODE, PASUBCODE, PARM1, PARM2, PARM3, PARM4, PARM5) VALUES
('COMPANY', 'NAME', 'ARCAD', 'Arcad Software Sample Application', '', 0, 0),
('COMPANY', 'ADDRESS', '123 Main', 'Paris, France', 'FR', 0, 0),
('COMPANY', 'CONTACT', '+33123456', 'contact@arcad.com', '', 0, 0),
('VAT', 'STANDARD', '20.00', 'Standard VAT Rate', '2', 2, 20),
('VAT', 'REDUCED', '10.00', 'Reduced VAT Rate', '1', 1, 10),
('VAT', 'ZERO', '0.00', 'Zero VAT Rate', '0', 0, 0),
('ORDER', 'PREFIX', 'ORD', 'Order number prefix', '', 0, 0),
('ORDER', 'LASTNUM', '10', 'Last order number used', '', 0, 10),
('CURRENCY', 'DEFAULT', 'EUR', 'Euro', '', 0, 978),
('LANGUAGE', 'DEFAULT', 'EN', 'English', '', 0, 0);

-- ============================================================================
-- Verification Queries
-- ============================================================================
-- Run these to verify data was inserted correctly:

-- SELECT COUNT(*) AS COUNTRY_COUNT FROM SAMCO.COUNTRY;
-- SELECT COUNT(*) AS FAMILY_COUNT FROM SAMCO.FAMILLY;
-- SELECT COUNT(*) AS ARTICLE_COUNT FROM SAMCO.ARTICLE;
-- SELECT COUNT(*) AS PROVIDER_COUNT FROM SAMCO.PROVIDER;
-- SELECT COUNT(*) AS CUSTOMER_COUNT FROM SAMCO.CUSTOMER;
-- SELECT COUNT(*) AS ORDER_COUNT FROM SAMCO.ORDER;
-- SELECT COUNT(*) AS DETORD_COUNT FROM SAMCO.DETORD;
-- SELECT COUNT(*) AS ARTIPROV_COUNT FROM SAMCO.ARTIPROV;
-- SELECT COUNT(*) AS PARAMETER_COUNT FROM SAMCO.PARAMETER;

-- ============================================================================
-- Sample Queries for Testing
-- ============================================================================

-- Get all articles with family and VAT information
-- SELECT 
--     a.ARID, a.ARDESC, a.ARSALEPR, a.ARSTOCK,
--     f.FADESC AS FAMILY, a.ARVATCD
-- FROM SAMCO.ARTICLE a
-- LEFT JOIN SAMCO.FAMILLY f ON a.ARTIFA = f.FAID
-- WHERE a.ARDEL = ''
-- ORDER BY a.ARID;

-- Get all orders with customer information
-- SELECT 
--     o.ORID, o.ORDATE, c.CUSTNM, c.CUCITY
-- FROM SAMCO.ORDER o
-- JOIN SAMCO.CUSTOMER c ON o.ORCUID = c.CUID
-- ORDER BY o.ORDATE DESC;

-- Get order details with article information
-- SELECT 
--     d.ODORID, d.ODLINE, a.ARDESC, d.ODQTY, d.ODPRICE, d.ODTOT
-- FROM SAMCO.DETORD d
-- JOIN SAMCO.ARTICLE a ON d.ODARID = a.ARID
-- WHERE d.ODORID = 1
-- ORDER BY d.ODLINE;

-- ============================================================================
-- End of Script
-- ============================================================================

-- Made with Bob