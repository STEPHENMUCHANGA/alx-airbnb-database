## Apply Aggregations and Window Functions

### Objective
#### Use SQL aggregation and window functions to analyze data.

### Aggregation with COUNT and GROUP BY
#### Find the total number of bookings made by each user

- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - COUNT(b.booking_id) AS total_bookings
- FROM 
    - User u
- JOIN 
    - Booking b ON u.user_id = b.user_id
- GROUP BY 
    u.user_id, u.first_name, u.last_name;

#### Explanation:
#### This groups bookings by user and counts how many bookings each has made.

### Window Function with RANK
#### Rank properties based on the total number of bookings they have received

- SELECT 
    - property_id,
    - total_bookings,
    - RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
- FROM (
    - SELECT 
        - b.property_id,
        - COUNT(b.booking_id) AS total_bookings
    - FROM 
        - Booking b
    - GROUP BY 
        - b.property_id
) AS booking_stats;

#### Explanation:

#### The inner query counts the total bookings per property.

#### The outer query uses RANK() to assign a ranking to each property based on booking count in descending order (most booked = rank 1).
