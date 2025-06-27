## Define Entities and Relationships in ER Diagram

## Objective
### Create an Entity-Relationship (ER) diagram based on the Airbnb database specification.

## Entities and Attributes

#### User ↔ Property
Relationship: One-to-Many
Description: A single user (with role host) can create multiple properties.
Foreign Key: Property.host_id → User.user_id
#### User ↔ Booking
Relationship: One-to-Many
Description: A user (typically a guest) can make many bookings.
Foreign Key: Booking.user_id → User.user_id
#### Property ↔ Booking
Relationship: One-to-Many
Description: A property can have multiple bookings.
Foreign Key: Booking.property_id → Property.property_id
#### Booking ↔ Payment
Relationship: One-to-One (or One-to-Many if allowing partial payments)
Description: Each booking has one payment record, assuming full payment at once.
Foreign Key: Payment.booking_id → Booking.booking_id
#### User ↔ Review
Relationship: One-to-Many
Description: A user can write multiple reviews.
Foreign Key: Review.user_id → User.user_id
#### Property ↔ Review
Relationship: One-to-Many
Description: A property can have multiple reviews written by different users.
Foreign Key: Review.property_id → Property.property_id
#### User ↔ Message (Sender & Recipient)
Relationship: One-to-Many (twice)
Description: A user can send and receive multiple messages.
Foreign Keys:
  -Message.sender_id → User.user_id
  -Message.recipient_id → User.user_id
