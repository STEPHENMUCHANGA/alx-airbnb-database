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

No actionable changes are required to achieve 3NF at this stage.






