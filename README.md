# requirements.md
# Define Entities and Relationships in ER Diagram
## ERD
## Objective
Create an Entity-Relationship (ER) diagram based on the Airbnb database specification.

## Entities and Attributes

### User ↔ Property
Relationship: One-to-Many
Description: A single user (with role host) can create multiple properties.
Foreign Key: Property.host_id → User.user_id
### User ↔ Booking
Relationship: One-to-Many
Description: A user (typically a guest) can make many bookings.
Foreign Key: Booking.user_id → User.user_id
### Property ↔ Booking
Relationship: One-to-Many
Description: A property can have multiple bookings.
Foreign Key: Booking.property_id → Property.property_id
### Booking ↔ Payment
Relationship: One-to-One (or One-to-Many if allowing partial payments)
Description: Each booking has one payment record, assuming full payment at once.
Foreign Key: Payment.booking_id → Booking.booking_id
### User ↔ Review
Relationship: One-to-Many
Description: A user can write multiple reviews.
Foreign Key: Review.user_id → User.user_id
### Property ↔ Review
Relationship: One-to-Many
Description: A property can have multiple reviews written by different users.
Foreign Key: Review.property_id → Property.property_id
### User ↔ Message (Sender & Recipient)
Relationship: One-to-Many (twice)
Description: A user can send and receive multiple messages.
Foreign Keys:
  -Message.sender_id → User.user_id
  -Message.recipient_id → User.user_id

## ER Diagram
![requirement md](https://github.com/user-attachments/assets/80745473-99e4-4347-ae76-2a1ddd066cf0)

# normalization.md
# Normalize Your Database Design
## Objective
### This document outlines the normalization process used to ensure the Airbnb database schema follows Third Normal Form (3NF), thereby minimizing redundancy and maintaining data integrity.
## Normalization principles 
### A relation is in:
- **1NF**: All values are atomic and there are no repeating groups.
- **2NF**: It is in 1NF and all non-primary key attributes are fully functionally dependent on the entire primary key.
- **3NF**: It is in 2NF and there are no transitive dependencies.
## Entity reviews
### 1. User
- Attributes are atomic
-  No partial or transitive dependencies
-  In 3NF

### 2. Property
-  Fully depends on `property_id`
-  `host_id` is a Foreign Key to User
-  In 3NF

### 3. Booking
-  All fields atomic
-  No derived fields (e.g., total price is stored, not recalculated)
-  In 3NF

### 4. Payment
-  One-to-One or One-to-Many relationship with Booking
-  No transitive dependency
-  In 3NF

### 5. Review
-  Fields are atomic
-  References both User and Property appropriately
-  In 3NF

### 6. Message
-  Sender and Recipient are foreign keys to User
-  Each message stored atomically
-  In 3NF
## Conclusion

The database schema is well-structured and adheres to 3NF. There are no redundant fields in the tables, no derived columns, and all non-key attributes are directly and fully dependent on their primary keys.

No actionable changes are required to achieve 3NF at this stage

# Design Database Schema (DDL)
## Objective
### Write SQL queries to define the database schema (create tables, set constraints)
## SQL Script: Airbnb Database Schema (schema.sql)
-- Airbnb Database Schema - DDL Definition

-- Drop tables if they exist (for development/testing use)
DROP TABLE IF EXISTS Message, Review, Payment, Booking, Property, User CASCADE;

-- Table: User

### CREATE TABLE User (
   ##### user_id UUID PRIMARY KEY,
   ##### first_name VARCHAR(50) NOT NULL,
   ##### last_name VARCHAR(50) NOT NULL,
   ##### email VARCHAR(100) UNIQUE NOT NULL,
   ##### password_hash VARCHAR(255) NOT NULL,
   ##### phone_number VARCHAR(20),
   ##### role ENUM('guest', 'host', 'admin') NOT NULL,
   ##### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster email lookup
CREATE INDEX idx_user_email ON User(email);

-- Table: Property

### CREATE TABLE Property (
   ##### property_id UUID PRIMARY KEY,
   ##### host_id UUID NOT NULL,
   ##### name VARCHAR(100) NOT NULL,
   ##### description TEXT NOT NULL,
   ##### location VARCHAR(150) NOT NULL,
   ##### pricepernight DECIMAL(10,2) NOT NULL,
   ##### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   ##### updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

   ##### FOREIGN KEY (host_id) REFERENCES User(user_id)
);

-- Index for location-based queries
CREATE INDEX idx_property_location ON Property(location);

-- Table: Booking

### CREATE TABLE Booking (
   ##### booking_id UUID PRIMARY KEY,
   ##### property_id UUID NOT NULL,
   ##### user_id UUID NOT NULL,
   ##### start_date DATE NOT NULL,
   ##### end_date DATE NOT NULL,
   ##### total_price DECIMAL(10,2) NOT NULL,
   ##### status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
   ##### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ##### FOREIGN KEY (property_id) REFERENCES Property(property_id),
   ##### FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Indexes for property and user searches
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Table: Payment

### CREATE TABLE Payment (
   ##### payment_id UUID PRIMARY KEY,
   ##### booking_id UUID NOT NULL,
   ##### amount DECIMAL(10,2) NOT NULL,
   ##### payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   ##### payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,

   ##### FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Index on payment date
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Table: Review

### CREATE TABLE Review (
   ##### review_id UUID PRIMARY KEY,
   ##### property_id UUID NOT NULL,
   ##### user_id UUID NOT NULL,
   ##### rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
   ##### comment TEXT NOT NULL,
   ##### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ##### FOREIGN KEY (property_id) REFERENCES Property(property_id),
   ##### FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Composite index for property + rating
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Table: Message

### CREATE TABLE Message (
   ##### message_id UUID PRIMARY KEY,
   ##### sender_id UUID NOT NULL,
   ##### recipient_id UUID NOT NULL,
   ##### message_body TEXT NOT NULL,
   ##### sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ##### FOREIGN KEY (sender_id) REFERENCES User(user_id),
   ##### FOREIGN KEY (recipient_id) REFERENCES User(user_id)
);

-- Indexes for conversation performance
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

## Important Notes
- All UUIDs are used as primary keys for uniqueness and scalability.

- Proper foreign key constraints ensure referential integrity.

- ENUMs are used for roles, statuses, and payment methods.

- Indexes are created on frequently searched fields (emails, locations, user IDs).

- ON UPDATE CURRENT_TIMESTAMP is used to automatically track changes in Property.

# Seed the Database with Sample Data
## Objective
### Create SQL scripts to populate the database with sample data.
## SQL Script: Seed the Database with Sample Data (seed.sql)

-- Airbnb Sample Data Seeding Script

-- Seed Users
##### INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
##### VALUES
##### ('a1111111-1111-1111-1111-111111111111', 'Alice', 'Walker', 'alice@example.com', 'hashed_pw1', '0712345678', 'host'),
##### ('a2222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw2', '0723456789', 'guest'),
##### ('a3333333-3333-3333-3333-333333333333', 'Charlie', 'Doe', 'charlie@example.com', 'hashed_pw3', '0734567890', 'guest');

-- Seed Properties
##### INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
##### VALUES
##### ('b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Cozy Cabin', 'A beautiful cabin in the woods.', 'Lake District, UK', 85.00),
##### ('b2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Urban Loft', 'Modern loft in city centre.', 'Manchester, UK', 120.00);

-- Seed Bookings
##### INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
##### VALUES
##### ('c1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', '2025-07-10', '2025-07-15', 425.00, 'confirmed'),
##### ('c2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 'a3333333-3333-3333-3333-333333333333', '2025-08-01', '2025-08-05', 480.00, 'pending');

-- Seed Payments
##### INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
##### VALUES
##### ('d1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111', 425.00, 'credit_card'),
##### ('d2222222-2222-2222-2222-222222222222', 'c2222222-2222-2222-2222-222222222222', 480.00, 'paypal');

-- Seed Reviews
##### INSERT INTO Review (review_id, property_id, user_id, rating, comment)
##### VALUES
##### ('e1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 5, 'Amazing cabin, peaceful and clean.'),
##### ('e2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 'a3333333-3333-3333-3333-333333333333', 4, 'Nice place, just a bit noisy at night.');

-- Seed Messages
##### INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
##### VALUES
##### ('f1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Hi Alice, is the cabin available for next weekend?'),
##### ('f2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'Yes, it is available! Feel free to book.');







