## Seed the Database with Sample Data

### Objective

#### Create SQL scripts to populate the database with sample data.

### SQL Script: Seed the Database with Sample Data (seed.sql)

-- Airbnb Sample Data Seeding Script

-- Seed Users
###### INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
###### ('a1111111-1111-1111-1111-111111111111', 'Alice', 'Walker', 'alice@example.com', 'hashed_pw1', '0712345678', 'host'),
###### ('a2222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw2', '0723456789', 'guest'),
###### ('a3333333-3333-3333-3333-333333333333', 'Charlie', 'Doe', 'charlie@example.com', 'hashed_pw3', '0734567890', 'guest');

-- Seed Properties
###### INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
###### VALUES
###### ('b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Cozy Cabin', 'A beautiful cabin in the woods.', 'Lake District, UK', 85.00),
###### ('b2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Urban Loft', 'Modern loft in city centre.', 'Manchester, UK', 120.00);

-- Seed Bookings
###### INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
###### VALUES
###### ('c1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', '2025-07-10', '2025-07-15', 425.00, 'confirmed'),
###### ('c2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 'a3333333-3333-3333-3333-333333333333', '2025-08-01', '2025-08-05', 480.00, 'pending');

-- Seed Payments
###### INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
###### VALUES
###### ('d1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111', 425.00, 'credit_card'),
###### ('d2222222-2222-2222-2222-222222222222', 'c2222222-2222-2222-2222-222222222222', 480.00, 'paypal');

-- Seed Reviews
###### INSERT INTO Review (review_id, property_id, user_id, rating, comment)
###### VALUES
###### ('e1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 5, 'Amazing cabin, peaceful and clean.'),
###### ('e2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 'a3333333-3333-3333-3333-333333333333', 4, 'Nice place, just a bit noisy at night.');

-- Seed Messages
###### INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
###### VALUES
###### ('f1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Hi Alice, is the cabin available for next weekend?'),
###### ('f2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'Yes, it is available! Feel free to book.');
