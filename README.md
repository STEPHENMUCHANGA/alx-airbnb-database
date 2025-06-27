git clone https://github.com/STEPHENMUCHANGA/alx-airbnb-database.git
cd alx-airbnb-database
mkdir ERD
touch ERD/requirements.md
# ERD Requirements

## Objective
Create an Entity-Relationship (ER) diagram based on the Airbnb database specification.

## Entities and Attributes

### User
- user_id (PK)
- first_name
- last_name
- email
- password_hash
- phone_number
- role
- created_at

### Property
- property_id (PK)
- host_id (FK → User)
- name
- description
- location
- pricepernight
- created_at
- updated_at

...

## Relationships
- A User can own many Properties.
- A User can make many Bookings.
- A Property can have many Bookings.
- A Booking has one Payment.
- A Property can have many Reviews.
- A User can send and receive Messages.

## ER Diagram
(See ERD/airbnb_erd.png or airbnb_erd.drawio)
mv ~/Downloads/airbnb_erd.png ERD/
git add .
git commit -m "Add ERD directory, requirements.md, and ER diagram"
git push origin main






