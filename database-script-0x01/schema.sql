## Design Database Schema (DDL)

### Objective

#### Write SQL queries to define the database schema (create tables, set constraints)

#### SQL Script: Airbnb Database Schema (schema.sql)
-- Airbnb Database Schema - DDL Definition

-- Drop tables if they exist (for development/testing use)
DROP TABLE IF EXISTS Message, Review, Payment, Booking, Property, User CASCADE;

-- Table: User

##### CREATE TABLE User (
   ###### user_id UUID PRIMARY KEY,
   ###### first_name VARCHAR(50) NOT NULL,
   ###### last_name VARCHAR(50) NOT NULL,
   ###### email VARCHAR(100) UNIQUE NOT NULL,
   ###### password_hash VARCHAR(255) NOT NULL,
   ###### phone_number VARCHAR(20),
   ###### role ENUM('guest', 'host', 'admin') NOT NULL,
   ###### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster email lookup
CREATE INDEX idx_user_email ON User(email);

-- Table: Property

#### CREATE TABLE Property (
   ###### property_id UUID PRIMARY KEY,
   ###### host_id UUID NOT NULL,
   ###### name VARCHAR(100) NOT NULL,
   ###### description TEXT NOT NULL,
   ###### location VARCHAR(150) NOT NULL,
   ###### pricepernight DECIMAL(10,2) NOT NULL,
   ###### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   ###### updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

   ###### FOREIGN KEY (host_id) REFERENCES User(user_id)
);

-- Index for location-based queries
CREATE INDEX idx_property_location ON Property(location);

-- Table: Booking

#### CREATE TABLE Booking (
   ###### booking_id UUID PRIMARY KEY,
   ###### property_id UUID NOT NULL,
   ###### user_id UUID NOT NULL,
   ###### start_date DATE NOT NULL,
   ###### end_date DATE NOT NULL,
   ###### status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
   ###### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ###### FOREIGN KEY (property_id) REFERENCES Property(property_id),
   ###### FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Indexes for property and user searches
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Table: Payment

#### CREATE TABLE Payment (
   ###### payment_id UUID PRIMARY KEY,
   ###### booking_id UUID NOT NULL,
   ###### amount DECIMAL(10,2) NOT NULL,
   ###### payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   ###### payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,

   ###### FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Index on payment date
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Table: Review

#### CREATE TABLE Review (
   ###### review_id UUID PRIMARY KEY,
   ###### property_id UUID NOT NULL,
   ###### user_id UUID NOT NULL,
   ###### rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
   ###### comment TEXT NOT NULL,
   ###### created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ###### FOREIGN KEY (property_id) REFERENCES Property(property_id),
   ###### FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Composite index for property + rating
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Table: Message

#### CREATE TABLE Message (
   ###### message_id UUID PRIMARY KEY,
   ###### sender_id UUID NOT NULL,
   ###### recipient_id UUID NOT NULL,
   ###### message_body TEXT NOT NULL,
   ###### sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

   ###### FOREIGN KEY (sender_id) REFERENCES User(user_id),
   ###### FOREIGN KEY (recipient_id) REFERENCES User(user_id)
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
