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
