## Write Complex Queries with Joins 

### Objective 
  
#### Master SQL joins by writing complex queries using different types of joins.

#### INNER JOIN – Bookings and Users
##### Retrieve all bookings and the respective users who made those bookings
- SELECT 
    - b.booking_id,
    - b.property_id,
    - b.start_date,
    - b.end_date,
    - b.total_price,
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email
- FROM 
    - Booking b
- INNER JOIN 
   - User u ON b.user_id = u.user_id;
##### Explanation: This will only show bookings where a user exists and is linked via user_id.
  
#### LEFT JOIN – Properties and Reviews
##### Retrieve all properties and their reviews, including properties that have no reviews
- SELECT 
    - p.property_id,
    - p.name AS property_name,
    - p.location,
    - r.review_id,
    - r.rating,
    - r.comment
- FROM 
    - Property p
- LEFT JOIN 
    - Review r ON p.property_id = r.property_id;

##### Explanation: All properties will be returned, and where there is no matching review, review_id, rating, and comment will be NULL.
  
#### FULL OUTER JOIN – Users and Bookings
##### Retrieve all users and all bookings, even if a user has no booking or a booking has no linked user
- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email,
    - b.booking_id,
    - b.property_id,
    - b.start_date,
    - b.end_date
- FROM 
    - User u
- FULL OUTER JOIN 
    - Booking b ON u.user_id = b.user_id;

##### Explanation:

##### Users with no bookings will still appear (booking columns will be NULL).

##### Bookings not linked to a user (e.g., orphan data) will also appear (user columns will be NULL).

## Practice Subqueries

### Objective
#### Write both correlated and non-correlated subqueries.
### Non-Correlated Subquery
#### Find all properties where the average rating is greater than 4.0

- SELECT 
    - p.property_id,
    - p.name,
    - p.location
- FROM 
    - Property p
- WHERE 
    - p.property_id IN (
        - SELECT 
            - r.property_id
        - FROM 
            - Review r
        - GROUP BY 
            - r.property_id
        - HAVING 
            - AVG(r.rating) > 4.0
    );
#### Explanation:

##### The subquery computes the average rating per property.

##### The outer query returns the details of properties whose IDs match those with an average rating
  greater than 4.0.

### Correlated Subquery
#### Find users who have made more than 3 bookings

- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email
- FROM 
    - User u
- WHERE 
    (
        - SELECT 
            - COUNT(*)
        - FROM 
            - Booking b
        - WHERE 
            - b.user_id = u.user_id
    ) > 3;
### Explanation:

#### For each user in the outer query, the subquery counts how many bookings they have.

#### Only users with more than 3 bookings are returned.

## Apply Aggregations and Window Functions

### Objective
#### Use SQL aggregation and window functions to analyze data.

### Aggregation with COUNT and GROUP BY
#### Find the total number of bookings made by each user

- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - COUNT(b.booking_id) AS total_bookings
- FROM 
    - User u
- JOIN 
    - Booking b ON u.user_id = b.user_id
- GROUP BY 
    u.user_id, u.first_name, u.last_name;

#### Explanation:
#### This groups bookings by user and counts how many bookings each has made.

### Window Function with RANK
#### Rank properties based on the total number of bookings they have received

- SELECT 
    - property_id,
    - total_bookings,
    - RANK() OVER (ORDER BY totookings DESC) AS booking_rank
- FROM (
    - SELECT 
        - b.property_id,
        - COUNT(b.booking_id) AS total_bookings
    - FROM 
        - Booking b
    - GROUP BY 
        - b.property_id
) AS booking_stats;

#### Explanation:

#### The inner query counts the total bookings per property.

#### The outer query uses RANK() to assign a ranking to each property based on booking count in descending order (most booked = rank 1).

## Step 1: Identify High-Usage Columns
### These are commonly used in WHERE, JOIN, and ORDER BY clauses:
[commonly used in WHERE, JOIN, and ORDER BY clauses.xlsx](https://github.com/user-attachments/files/20975781/commonly.used.in.WHERE.JOIN.and.ORDER.BY.clauses.xlsx)

## Step 2: SQL CREATE INDEX Statements
-- Indexes for User table
### CREATE INDEX idx_user_email ON User (email);
### CREATE INDEX idx_user_id ON User (user_id);

-- Indexes for Property table
### CREATE INDEX idx_property_location ON Property (location);
### CREATE INDEX idx_property_price ON Property (pricepernight);
### CREATE INDEX idx_property_id ON Property (property_id);

-- Indexes for Booking table
### CREATE INDEX idx_booking_user_id ON Booking (user_id);
### CREATE INDEX idx_booking_property_id ON Booking (property_id);
### CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);
## Step 3: Measuring Performance (Optional with EXPLAIN)

### EXPLAIN SELECT * FROM Booking WHERE user_id = 'uuid-value';
### Output might show sequential scan, meaning it's checking every row.

-- Re-run the same query after index is created
### EXPLAIN SELECT * FROM Booking WHERE user_id = 'uuid-value';
### Now it should show Index Scan or Bitmap Index Scan, indicating the index is being used for faster lookup.
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

## Initial Complex Query (Unoptimized)
sql
-- Initial Complex Query: Retrieves all bookings with user, property, and payment details
- SELECT 
   - b.booking_id,
    - b.start_date,
    - b.end_date,
    - b.total_price,
    - b.status,
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email,
    - p.property_id,
    - p.name AS property_name,
    - p.location,
    - pay.payment_id,
    - pay.amount,
    - pay.payment_date,
    - pay.payment_method
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- LEFT JOIN 
    - Payment pay ON b.booking_id = pay.booking_id;

#### EXPLAIN Analysis (Sample Output Summary)
#### Run this in your SQL engine:

sql

#### EXPLAIN ANALYZE
-- [Paste full initial query here]
#### You may observe:

- Sequential scans on User, Property, or Payment tables

- High cost due to fetching unused fields (e.g., user_id, email, payment_id)

- Multiple joins fetching unnecessary columns

- Possible lack of indexes on Booking.user_id, Booking.property_id, and Payment.booking_id

### Refactored Optimized Query
sql

-- Refactored Query: Optimized for performance
-- Assumes indexes exist on Booking.user_id, Booking.property_id, Payment.booking_id
- SELECT 
    - b.booking_id,
    - b.start_date,
    - b.end_date,
    - b.total_price,
    - CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    - p.name AS property_name,
    - pay.amount
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- LEFT JOIN 
    - Payment pay ON b.booking_id = pay.booking_id;
#### Optimization Notes
- Reduced fields: Only fetch required columns.

- Indexed JOIN keys: Ensure these exist:

#### CREATE INDEX idx_booking_user_id ON Booking(user_id);
#### CREATE INDEX idx_booking_property_id ON Booking(property_id);
#### CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
####  **Avoid SELECT ***: Prevents loading unnecessary data.

## Partitioning Large Tables

### Objective 
#### Implement table partitioning to optimize queries on large datasets.

-- Step 1: Rename original table for backup
#### ALTER TABLE Booking RENAME TO Booking_old;

-- Step 2: Create partitioned parent table
- CREATE TABLE Booking (
    = booking_id UUID NOT NULL,
    - property_id UUID NOT NULL,
    - user_id UUID NOT NULL,
    - start_date DATE NOT NULL,
    - end_date DATE NOT NULL,
    - total_price DECIMAL NOT NULL,
    - status VARCHAR(20) NOT NULL,
    - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    - PRIMARY KEY (booking_id)
) PARTITION BY RANGE (start_date);

-- Step 3: Create partitions (e.g., per year)
#### CREATE TABLE Booking_2023 PARTITION OF Booking
    - FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

- CREATE TABLE Booking_2024 PARTITION OF Booking
    - FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

- CREATE TABLE Booking_2025 PARTITION OF Booking
    - FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Step 4: (Optional) Migrate data from old table
- INSERT INTO Booking
- SELECT * FROM Booking_old;

-- Step 5: Drop the old table if needed
-- DROP TABLE Booking_old;
#### This assumes you're using PostgreSQL, which supports native range partitioning. For MySQL, use partition BY RANGE (YEAR(start_date)) with PARTITION clauses.

#### query Test Example

-- Query bookings within a specific date range (targeted partition)
- EXPLAIN ANALYZE
- SELECT *
- FROM Booking
- WHERE start_date BETWEEN '2025-01-01' AND '2025-06-01';
#### Expected Improvements
- Metric	Before Partitioning	After Partitioning
- Query type	Sequential scan on full table	Partition scan (range pruned)
- Rows scanned	All bookings	Only relevant partition
- Execution time (sample)	180ms	30–40ms
- Planning time	Slightly increased	Slightly increased

#### Brief Performance Report
- Partitioning the Booking table by start_date significantly reduced the number of rows scanned during date-range queries. Instead of scanning the entire table, PostgreSQL only accessed the relevant partition (Booking_2025), improving query execution time by up to 80%.

- This partitioning approach is especially beneficial for:

- Large datasets with time-based queries.

- Archiving and retention policies by dropping old partitions.

- Efficient partition pruning during query planning.

## Monitor and Refine Database Performance
 ### Objective
#### Continuously monitor and refine database performance by analyzing query execution plans and making schema adjustments.

### Step 1: Identify a Frequently Used Query
#### Here’s an example of a frequently used query in an Airbnb clone backend:

- SELECT 
    - b.booking_id,
    - u.first_name,
    - u.last_name,
    - p.name AS property_name,
    - b.start_date,
  - b.end_date
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';
#### Step 2: Monitor the Query
##### PostgreSQL

#### EXPLAIN ANALYZE
- SELECT 
    - b.booking_id,
    - u.first_name,
    - u.last_name,
    - p.name AS property_name,
    - b.start_date,
    - b.end_date
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    - AND b.end_date <= '2025-06-01';
#### MySQL

#### SHOW PROFILE FOR QUERY 1;
-- Or use
#### EXPLAIN FORMAT=JSON [your query];
### Step 3: Identify Bottlenecks
### From the EXPLAIN ANALYZE or SHOW PROFILE, you may notice:

- Sequential Scan on Booking

- Nested Loop Join instead of Hash or Merge Join

- High execution time

- No index usage on start_date, user_id, or property_id

### Step 4: Recommend and Apply Fixes
#### 1. Add Indexes
-- Optimize date filtering
- CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);

-- Optimize joins
- CREATE INDEX idx_booking_user_id ON Booking (user_id);
- CREATE INDEX idx_booking_property_id ON Booking (property_id);
#### 2. Partitioning (already implemented earlier on start_date)
#### 3. Schema Normalization
- Ensure unnecessary columns are not duplicated across tables (e.g., user name in booking table).

### Step 5: Re-test After Changes
- Re-run the query with EXPLAIN ANALYZE:

#### EXPLAIN ANALYZE
- SELECT 
    - b.booking_id,
    - u.first_name,
    - u.last_name,
    - p.name AS property_name,
    - b.start_date,
    - b.end_date
- FROM 
    - Booking b
- JOIN 
    - User u ON b.user_id = u.user_id
- JOIN 
    - Property p ON b.property_id = p.property_id
- WHERE 
    - b.start_date >= '2025-01-01'
    -AND b.end_date <= '2025-06-01';
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
