-- ============================================================================
-- Sample Data Population Script for Article Management System
-- ============================================================================
-- This script populates the database with sample data for testing the
-- React web application.
--
-- Tables populated:
--   1. VATDEF   - VAT code definitions
--   2. FAMILLY  - Article families/categories
--   3. ARTICLE  - Article master data
--   4. ARTIINF  - Article extended information (if table exists)
--
-- Usage:
--   Run this script using RUNSQLSTM or ACS Run SQL Scripts
--   RUNSQLSTM SRCFILE(YOURLIB/QSQLSRC) SRCMBR(POPULATE_SAMPLE_DATA)
-- ============================================================================

-- Set library (adjust as needed)
-- SET SCHEMA YOURLIB;

-- ============================================================================
-- 1. POPULATE VAT DEFINITIONS
-- ============================================================================

-- Clear existing data (optional - comment out if you want to keep existing data)
DELETE FROM VATDEF WHERE VATCODE IN ('1', '2', '3', '4', '5');

-- Insert VAT codes
INSERT INTO VATDEF (VATCODE, VATRATE, VATDESC, VATCREA, VATMOD, VATMODID, VATDEL) VALUES
  ('1', 20.00, 'Standard Rate',     CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('2', 10.00, 'Reduced Rate',      CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('3',  5.50, 'Super Reduced',     CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('4',  0.00, 'Zero Rate',         CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('5', 21.00, 'Special Rate',      CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' ');

-- ============================================================================
-- 2. POPULATE ARTICLE FAMILIES
-- ============================================================================

-- Clear existing data (optional)
DELETE FROM FAMILLY WHERE FAID IN ('ELE', 'FUR', 'OFF', 'SPO', 'CLO', 'FOO', 'TOY', 'BOO');

-- Insert families
INSERT INTO FAMILLY (FAID, FADESC, FAVATCD, FACREA, FAMOD, FAMODID, FADEL) VALUES
  ('ELE', 'Electronics',                    '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('FUR', 'Furniture',                      '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('OFF', 'Office Supplies',                '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('SPO', 'Sports Equipment',               '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('CLO', 'Clothing',                       '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('FOO', 'Food & Beverages',               '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('TOY', 'Toys & Games',                   '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('BOO', 'Books & Media',                  '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' ');

-- ============================================================================
-- 3. POPULATE ARTICLES
-- ============================================================================

-- Clear existing data (optional)
DELETE FROM ARTICLE WHERE ARID LIKE 'ART%';

-- Insert sample articles
INSERT INTO ARTICLE (ARID, ARDESC, ARSALEPR, ARWHSPR, ARTIFA, ARSTOCK, ARMINQTY, 
                     ARCUSQTY, ARPURQTY, ARVATCD, ARCREA, ARMOD, ARMODID, ARDEL) VALUES

-- Electronics
  ('ART001', 'Laptop Computer 15 inch',              899.99,  650.00, 'ELE', 25,  10, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART002', 'Wireless Mouse Bluetooth',              29.99,   18.00, 'ELE', 150, 50, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART003', 'USB-C Hub 7 Ports',                     49.99,   32.00, 'ELE', 80,  20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART004', 'Mechanical Keyboard RGB',               89.99,   55.00, 'ELE', 45,  15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART005', 'Webcam HD 1080p',                       69.99,   42.00, 'ELE', 60,  20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART006', 'External SSD 1TB',                     129.99,   85.00, 'ELE', 35,  10, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART007', 'Wireless Headphones Noise Cancelling', 199.99,  135.00, 'ELE', 40,  15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART008', 'Smartphone Stand Adjustable',           19.99,   12.00, 'ELE', 200, 50, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Furniture
  ('ART009', 'Office Chair Ergonomic',               249.99,  165.00, 'FUR', 18,   5, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART010', 'Standing Desk Adjustable',             399.99,  275.00, 'FUR', 12,   3, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART011', 'Bookshelf 5 Tier',                     129.99,   85.00, 'FUR', 22,   5, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART012', 'Desk Lamp LED',                         39.99,   24.00, 'FUR', 75,  20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART013', 'Filing Cabinet 3 Drawer',              179.99,  120.00, 'FUR', 15,   5, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Office Supplies
  ('ART014', 'Notebook A4 Ruled 200 Pages',            4.99,    2.50, 'OFF', 500, 100, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART015', 'Ballpoint Pen Blue Box of 50',          12.99,    7.50, 'OFF', 300, 80, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART016', 'Sticky Notes 3x3 Pack of 12',            8.99,    5.00, 'OFF', 400, 100, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART017', 'Stapler Heavy Duty',                    19.99,   12.00, 'OFF', 120, 30, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART018', 'Paper Clips Box of 1000',                3.99,    2.00, 'OFF', 600, 150, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART019', 'Whiteboard Markers Set of 8',           14.99,    9.00, 'OFF', 250, 60, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART020', 'Document Folder A4 Pack of 10',          9.99,    6.00, 'OFF', 350, 80, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Sports Equipment
  ('ART021', 'Yoga Mat Premium 6mm',                  39.99,   24.00, 'SPO', 85,  20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART022', 'Dumbbell Set 2x5kg',                    49.99,   32.00, 'SPO', 45,  15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART023', 'Resistance Bands Set of 5',             24.99,   15.00, 'SPO', 120, 30, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART024', 'Jump Rope Speed',                       14.99,    9.00, 'SPO', 180, 40, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART025', 'Water Bottle 1L Insulated',             29.99,   18.00, 'SPO', 200, 50, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Clothing
  ('ART026', 'T-Shirt Cotton Basic White M',          19.99,   12.00, 'CLO', 250, 60, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART027', 'Jeans Denim Blue 32x32',                59.99,   38.00, 'CLO', 120, 30, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART028', 'Hoodie Fleece Grey L',                  49.99,   32.00, 'CLO', 95,  25, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART029', 'Socks Cotton Pack of 6',                14.99,    9.00, 'CLO', 400, 100, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART030', 'Baseball Cap Adjustable',               24.99,   15.00, 'CLO', 180, 45, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Food & Beverages
  ('ART031', 'Coffee Beans Premium 1kg',              24.99,   16.00, 'FOO', 150, 40, 0, 0, '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART032', 'Green Tea Organic 100 Bags',            12.99,    8.00, 'FOO', 200, 50, 0, 0, '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART033', 'Protein Bar Chocolate Box of 12',       19.99,   13.00, 'FOO', 180, 45, 0, 0, '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART034', 'Olive Oil Extra Virgin 500ml',          14.99,    9.50, 'FOO', 120, 30, 0, 0, '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART035', 'Honey Raw Organic 500g',                18.99,   12.00, 'FOO', 95,  25, 0, 0, '3', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Toys & Games
  ('ART036', 'Board Game Strategy Family',            39.99,   25.00, 'TOY', 65,  15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART037', 'Puzzle 1000 Pieces Landscape',          19.99,   12.00, 'TOY', 110, 30, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART038', 'Building Blocks Set 500 Pieces',        49.99,   32.00, 'TOY', 85,  20, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART039', 'Remote Control Car Racing',             79.99,   52.00, 'TOY', 45,  12, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART040', 'Action Figure Superhero',               24.99,   15.00, 'TOY', 150, 40, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Books & Media
  ('ART041', 'Programming Book Python Advanced',      49.99,   32.00, 'BOO', 75,  20, 0, 0, '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART042', 'Novel Fiction Bestseller',              14.99,    9.00, 'BOO', 200, 50, 0, 0, '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART043', 'Cookbook Mediterranean Cuisine',        29.99,   19.00, 'BOO', 95,  25, 0, 0, '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART044', 'Magazine Tech Monthly Subscription',    39.99,   28.00, 'BOO', 120, 30, 0, 0, '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART045', 'Audiobook Self-Help Digital',           19.99,   14.00, 'BOO', 999, 0, 0, 0, '4', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),

-- Additional mixed items
  ('ART046', 'Monitor 24 inch Full HD',              249.99,  175.00, 'ELE', 28,  8, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART047', 'Printer Wireless Color',               179.99,  125.00, 'ELE', 22,  6, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART048', 'Desk Organizer Bamboo',                 34.99,   22.00, 'OFF', 140, 35, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART049', 'Backpack Laptop 17 inch',               69.99,   45.00, 'OFF', 95,  25, 0, 0, '2', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' '),
  ('ART050', 'Fitness Tracker Smartwatch',           149.99,  105.00, 'SPO', 55,  15, 0, 0, '1', CURRENT DATE, CURRENT TIMESTAMP, 'ADMIN', ' ');

-- ============================================================================
-- 4. POPULATE ARTICLE EXTENDED INFORMATION (Optional)
-- ============================================================================
-- Note: This section assumes ARTIINF table exists
-- If the table doesn't exist, comment out this section or create it first

-- Uncomment the following lines if ARTIINF table exists:

/*
-- Clear existing data (optional)
DELETE FROM ARTIINF WHERE ARID LIKE 'ART%';

-- Insert extended information for selected articles
INSERT INTO ARTIINF (ARID, TEXT) VALUES
  ('ART001', 'High-performance laptop with Intel Core i7 processor, 16GB RAM, 512GB SSD. Perfect for business and creative work. Includes 1-year warranty and free shipping. Battery life up to 10 hours. Lightweight design at only 1.8kg.'),
  ('ART009', 'Ergonomic office chair with lumbar support, adjustable height and armrests. Breathable mesh back. Maximum weight capacity 150kg. 5-year warranty on gas lift. Available in black and grey colors.'),
  ('ART010', 'Electric standing desk with memory presets for 4 height positions. Smooth and quiet motor. Desktop size 160x80cm. Height range 72-122cm. Cable management system included. Easy assembly with included tools.'),
  ('ART021', 'Premium yoga mat made from eco-friendly TPE material. Non-slip surface on both sides. Includes carrying strap. Easy to clean. Dimensions: 183cm x 61cm x 6mm. Available in multiple colors.'),
  ('ART036', 'Award-winning strategy board game for 2-4 players. Average playtime 60-90 minutes. Suitable for ages 12+. Includes detailed rulebook in multiple languages. Highly replayable with multiple strategies.'),
  ('ART041', 'Comprehensive guide to advanced Python programming. Covers design patterns, async programming, testing, and performance optimization. 450 pages with practical examples. Includes access to online code repository.'),
  ('ART046', 'Full HD IPS monitor with 75Hz refresh rate. HDMI and DisplayPort inputs. VESA mount compatible. Ultra-thin bezels for multi-monitor setup. Built-in speakers. 3-year manufacturer warranty.'),
  ('ART050', 'Advanced fitness tracker with heart rate monitoring, sleep tracking, and GPS. Water resistant up to 50m. Battery life up to 7 days. Compatible with iOS and Android. Includes multiple sport modes.');
*/

-- ============================================================================
-- 5. VERIFICATION QUERIES
-- ============================================================================

-- Count records inserted
SELECT 'VAT Definitions' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT FROM VATDEF
UNION ALL
SELECT 'Families', COUNT(*) FROM FAMILLY
UNION ALL
SELECT 'Articles', COUNT(*) FROM ARTICLE;

-- Show sample of inserted data
SELECT 'Sample Articles by Family:' AS INFO FROM SYSIBM.SYSDUMMY1;

SELECT 
  A.ARTIFA AS FAMILY,
  F.FADESC AS FAMILY_NAME,
  COUNT(*) AS ARTICLE_COUNT,
  DECIMAL(AVG(A.ARSALEPR), 7, 2) AS AVG_PRICE,
  SUM(A.ARSTOCK) AS TOTAL_STOCK
FROM ARTICLE A
JOIN FAMILLY F ON A.ARTIFA = F.FAID
WHERE A.ARDEL = ' '
GROUP BY A.ARTIFA, F.FADESC
ORDER BY A.ARTIFA;

-- Show articles with low stock
SELECT 'Articles with Low Stock:' AS INFO FROM SYSIBM.SYSDUMMY1;

SELECT 
  ARID,
  ARDESC,
  ARSTOCK AS CURRENT_STOCK,
  ARMINQTY AS MIN_STOCK,
  (ARMINQTY - ARSTOCK) AS SHORTAGE
FROM ARTICLE
WHERE ARSTOCK < ARMINQTY
  AND ARDEL = ' '
ORDER BY (ARMINQTY - ARSTOCK) DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================

-- Made with Bob
