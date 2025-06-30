### Step 1: Identify High-Usage Columns
#### These are commonly used in WHERE, JOIN, and ORDER BY clauses:
[commonly used in WHERE, JOIN, and ORDER BY clauses.xlsx](https://github.com/user-attachments/files/20975781/commonly.used.in.WHERE.JOIN.and.ORDER.BY.clauses.xlsx)

### Step 2: SQL CREATE INDEX Statements
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
