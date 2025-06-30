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
