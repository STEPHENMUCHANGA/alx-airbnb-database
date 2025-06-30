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
