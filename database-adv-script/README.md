## Write Complex Queries with Joins 

### Objective 
  
#### Master SQL joins by writing complex queries using different types of joins.

#### INNER JOIN – Bookings and Users
##### Retrieve all bookings and the respective users who made those bookings
- SELECT 
    - b.booking_id,
    - b.property_id,
    - b.start_date,
    - b.end_date,
    - b.total_price,
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email
- FROM 
    - Booking b
- INNER JOIN 
   - User u ON b.user_id = u.user_id;
##### Explanation: This will only show bookings where a user exists and is linked via user_id.
  
#### LEFT JOIN – Properties and Reviews
##### Retrieve all properties and their reviews, including properties that have no reviews
- SELECT 
    - p.property_id,
    - p.name AS property_name,
    - p.location,
    - r.review_id,
    - r.rating,
    - r.comment
- FROM 
    - Property p
- LEFT JOIN 
    - Review r ON p.property_id = r.property_id;

##### Explanation: All properties will be returned, and where there is no matching review, review_id, rating, and comment will be NULL.
  
#### FULL OUTER JOIN – Users and Bookings
##### Retrieve all users and all bookings, even if a user has no booking or a booking has no linked user
- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email,
    - b.booking_id,
    - b.property_id,
    - b.start_date,
    - b.end_date
- FROM 
    - User u
- FULL OUTER JOIN 
    - Booking b ON u.user_id = b.user_id;

##### Explanation:

##### Users with no bookings will still appear (booking columns will be NULL).

##### Bookings not linked to a user (e.g., orphan data) will also appear (user columns will be NULL).

## Practice Subqueries

### Objective
#### Write both correlated and non-correlated subqueries.
### Non-Correlated Subquery
#### Find all properties where the average rating is greater than 4.0

- SELECT 
    - p.property_id,
    - p.name,
    - p.location
- FROM 
    - Property p
- WHERE 
    - p.property_id IN (
        - SELECT 
            - r.property_id
        - FROM 
            - Review r
        - GROUP BY 
            - r.property_id
        - HAVING 
            - AVG(r.rating) > 4.0
    );
#### Explanation:

##### The subquery computes the average rating per property.

##### The outer query returns the details of properties whose IDs match those with an average rating
  greater than 4.0.

### Correlated Subquery
#### Find users who have made more than 3 bookings

- SELECT 
    - u.user_id,
    - u.first_name,
    - u.last_name,
    - u.email
- FROM 
    - User u
- WHERE 
    (
        - SELECT 
            - COUNT(*)
        - FROM 
            - Booking b
        - WHERE 
            - b.user_id = u.user_id
    ) > 3;
### Explanation:

#### For each user in the outer query, the subquery counts how many bookings they have.

#### Only users with more than 3 bookings are returned.

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
    - RANK() OVER (ORDER BY totookings DESC) AS booking_rank
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
