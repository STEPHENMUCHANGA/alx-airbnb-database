#### User Table

-- Index to speed up user lookups and joins
- CREATE INDEX idx_user_user_id ON User(user_id);

-- Index to speed up login and uniqueness checks
CREATE INDEX idx_user_email ON User(email);
#### Property Table

-- Index for JOIN operations and filters on property_id
- CREATE INDEX idx_property_property_id ON Property(property_id);

-- Index for location-based search queries
- CREATE INDEX idx_property_location ON Property(location);

-- Index for filtering by price ranges
- CREATE INDEX idx_property_price ON Property(pricepernight);
#### Booking Table

-- Index for JOINs between Booking and User
- CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index for JOINs between Booking and Property
- CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Composite index to improve performance of date-range queries
- CREATE INDEX idx_booking_start_end_date ON Booking(start_date, end_date);
#### Before Adding Indexes:

-- Run this BEFORE index creation
#### EXPLAIN ANALYZE
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
    -b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';
#### After Adding Indexes:

-- Run again AFTER indexes are created
#### EXPLAIN ANALYZE
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
#### Expected result after indexing:
- Index Scans instead of Sequential Scans

#### Execution time significantly reduced (e.g., 40ms–80ms)

- Metric	Before Indexing	After Indexing
- Rows Scanned	~250,000	~15,000
- Execution Time	300–400 ms	40–80 ms
- Scan Type	Seq Scan	Index Scan
- CPU Load	Higher	Lower

- Indexes significantly reduce execution time, particularly for JOINs and filtered queries. Regularly analyze query plans to identify new optimization opportunities.

#### User Table

-- Index to speed up user lookups and joins
-CREATE INDEX idx_user_user_id ON User(user_id);

-- Index to speed up login and uniqueness checks
- CREATE INDEX idx_user_email ON User(email);
#### Property Table

-- Index for JOIN operations and filters on property_id
- CREATE INDEX idx_property_property_id ON Property(property_id);

-- Index for location-based search queries
- CREATE INDEX idx_property_location ON Property(location);

-- Index for filtering by price ranges
- CREATE INDEX idx_property_price ON Property(pricepernight);
#### Booking Table

-- Index for JOINs between Booking and User
- CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index for JOINs between Booking and Property
- CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Composite index to improve performance of date-range queries
-CREATE INDEX idx_booking_start_end_date ON Booking(start_date, end_date);
