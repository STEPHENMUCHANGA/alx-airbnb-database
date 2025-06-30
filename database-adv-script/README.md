## Write Complex Queries with Joins 

### Objective 
  
#### Master SQL joins by writing complex queries using different types of joins.

#### INNER JOIN – Bookings and Users
##### Retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id;
##### Explanation: This will only show bookings where a user exists and is linked via user_id.
  
#### LEFT JOIN – Properties and Reviews
##### Retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id;

##### Explanation: All properties will be returned, and where there is no matching review, review_id, rating, and comment will be NULL.
  
#### FULL OUTER JOIN – Users and Bookings
##### Retrieve all users and all bookings, even if a user has no booking or a booking has no linked user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id;

##### Explanation:

##### Users with no bookings will still appear (booking columns will be NULL).

##### Bookings not linked to a user (e.g., orphan data) will also appear (user columns will be NULL).
