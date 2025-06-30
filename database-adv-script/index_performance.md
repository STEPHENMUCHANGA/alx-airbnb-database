### Step 1: Identify High-Usage Columns
#### These are commonly used in WHERE, JOIN, and ORDER BY clauses:
[commonly used in WHERE, JOIN, and ORDER BY clauses.xlsx](https://github.com/user-attachments/files/20975781/commonly.used.in.WHERE.JOIN.and.ORDER.BY.clauses.xlsx)

### Step 2: SQL CREATE INDEX Statements
#### commands to create appropriate indexes for those columns and save them on database_index.sql
-- Indexes for User table
#### CREATE INDEX idx_user_email ON User (email);
#### CREATE INDEX idx_user_id ON User (user_id);

-- Indexes for Property table
#### CREATE INDEX idx_property_location ON Property (location);
#### CREATE INDEX idx_property_price ON Property (pricepernight);
#### CREATE INDEX idx_property_id ON Property (property_id);

-- Indexes for Booking table
#### CREATE INDEX idx_booking_user_id ON Booking (user_id);
#### CREATE INDEX idx_booking_property_id ON Booking (property_id);
#### CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);
## Step 3: Measuring Performance (Optional with EXPLAIN)

#### EXPLAIN SELECT * FROM Booking WHERE user_id = 'uuid-value';
#### Output might show sequential scan, meaning it's checking every row.

-- Re-run the same query after index is created
#### EXPLAIN SELECT * FROM Booking WHERE user_id = 'uuid-value';
#### Now it should show Index Scan or Bitmap Index Scan, indicating the index is being used for faster lookup.

#### SQL Index Optimization Script
-- 🔹 Indexes for User table
- CREATE INDEX idx_user_email ON User (email);
- CREATE INDEX idx_user_id ON User (user_id);

-- 🔹 Indexes for Property table
- CREATE INDEX idx_property_location ON Property (location);
- CREATE INDEX idx_property_price ON Property (pricepernight);
- CREATE INDEX idx_property_id ON Property (property_id);

-- 🔹 Indexes for Booking table
- CREATE INDEX idx_booking_user_id ON Booking (user_id);
- CREATE INDEX idx_booking_property_id ON Booking (property_id);
- CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);

-- 🔎 Example performance test using EXPLAIN ANALYZE (PostgreSQL)
##### EXPLAIN ANALYZE
- SELECT 
    - b.booking_id,
    - b.start_date,
    - b.end_date,
    - u.first_name,
    - u.last_name,
    - p.name AS property_name
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';

##### Benefits of These Indexes
- Table	Indexed Column(s)	Performance Improvement Use Case
- User	email, user_id	Login lookups, foreign key joins
- Property	location, pricepernight, property_id	Filters and joins
- Booking	user_id, property_id, (start_date, end_date)	Joins and date range filtering

#### Measure Performance Using EXPLAIN ANALYZE
##### Before Adding Indexes:
-- Run this BEFORE index creation
##### EXPLAIN ANALYZE
-SELECT 
    - b.booking_id,
    - b.start_date,
    - b.end_date,
    - u.first_name,
    - p.name AS property_name
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';
##### Typical result before indexing:
##### Full Table Scans (Sequential Scans)

- High execution time (e.g., 200ms–400ms on large datasets)

#### After Adding Indexes:

-- Run again AFTER indexes are created
##### EXPLAIN ANALYZE
- SELECT 
    - b.booking_id,
    - b.start_date,
    - b.end_date,
    - u.first_name,
    - p.name AS property_name
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';
##### Expected result after indexing:
##### Index Scans instead of Sequential Scans

- Execution time significantly reduced (e.g., 40ms–80ms)
