CREATE DATABASE railway_analysis;

USE railway_analysis;

CREATE TABLE railway_data (
    journey_id VARCHAR(20) PRIMARY KEY,
    train_id VARCHAR(20),
    train_name VARCHAR(100),
    source_station VARCHAR(100),
    destination_station VARCHAR(100),
    journey_date DATE,
    passenger_count INT,
    ticket_fare DECIMAL(10,2),
    scheduled_time TIME,
    actual_time TIME,
    delay_minutes INT,
    cancellation VARCHAR(10),
    train_type VARCHAR(50)
);



INSERT INTO railway_data
(journey_id, train_id, train_name, source_station, destination_station,
 journey_date, passenger_count, ticket_fare, scheduled_time,
 actual_time, delay_minutes, cancellation, train_type)
VALUES
('J001','T101','Deccan Express','Mumbai','Pune','2026-01-05',420,180,'08:00:00','08:12:00',12,'No','Express'),

('J002','T102','Vidarbha Express','Nagpur','Mumbai','2026-01-07',650,450,'10:00:00','10:05:00',5,'No','Express'),

('J003','T103','Godavari Express','Hyderabad','Nagpur','2026-01-10',520,380,'07:30:00','07:55:00',25,'No','Express'),

('J004','T104','Maharashtra Express','Nagpur','Pune','2026-01-12',580,420,'09:00:00','09:08:00',8,'No','Express'),

('J005','T105','Intercity Express','Pune','Mumbai','2026-01-15',490,200,'06:30:00','06:30:00',0,'No','Intercity'),

('J006','T106','Nagpur Express','Nagpur','Mumbai','2026-01-18',610,460,'11:00:00','11:32:00',32,'No','Superfast'),

('J007','T107','Pune Express','Pune','Nagpur','2026-01-20',450,350,'08:30:00','08:40:00',10,'No','Express'),

('J008','T108','Mumbai Express','Mumbai','Nagpur','2026-01-22',700,500,'12:00:00','12:18:00',18,'No','Superfast'),

('J009','T109','Deccan Queen','Mumbai','Pune','2026-01-25',550,250,'17:00:00','17:03:00',3,'No','Express'),

('J010','T110','Central Express','Nagpur','Bhopal','2026-01-27',380,280,'13:00:00','13:00:00',0,'No','Express'),

('J011','T101','Deccan Express','Mumbai','Pune','2026-02-02',430,180,'08:00:00','08:07:00',7,'No','Express'),

('J012','T102','Vidarbha Express','Nagpur','Mumbai','2026-02-05',680,450,'10:00:00','10:20:00',20,'No','Express'),

('J013','T103','Godavari Express','Hyderabad','Nagpur','2026-02-08',540,380,'07:30:00','07:45:00',15,'No','Express'),

('J014','T104','Maharashtra Express','Nagpur','Pune','2026-02-10',600,420,'09:00:00','09:04:00',4,'No','Express'),

('J015','T105','Intercity Express','Pune','Mumbai','2026-02-13',510,200,'06:30:00','06:38:00',8,'No','Intercity'),

('J016','T106','Nagpur Express','Nagpur','Mumbai','2026-02-16',630,460,'11:00:00','11:10:00',10,'No','Superfast'),

('J017','T107','Pune Express','Pune','Nagpur','2026-02-18',470,350,'08:30:00','08:35:00',5,'No','Express'),

('J018','T108','Mumbai Express','Mumbai','Nagpur','2026-02-21',720,500,'12:00:00','12:25:00',25,'No','Superfast'),

('J019','T109','Deccan Queen','Mumbai','Pune','2026-02-24',570,250,'17:00:00','17:02:00',2,'No','Express'),

('J020','T110','Central Express','Nagpur','Bhopal','2026-02-27',400,280,'13:00:00','13:12:00',12,'No','Express');


-- 1.Revenue
SELECT
    journey_id,
    passenger_count,
    ticket_fare,
    passenger_count * ticket_fare AS revenue
FROM railway_data;

-- 2.Check duplicates
SELECT
    journey_id,
    COUNT(*) AS duplicate_count
FROM railway_data
GROUP BY journey_id
HAVING COUNT(*) > 1;

-- 3.check missing values
SELECT *
FROM railway_data
WHERE journey_id IS NULL
   OR train_id IS NULL
   OR train_name IS NULL
   OR source_station IS NULL
   OR destination_station IS NULL
   OR journey_date IS NULL
   OR passenger_count IS NULL
   OR ticket_fare IS NULL;
   
   
   -- 4.check invalid passenger counts
   SELECT *
FROM railway_data
WHERE passenger_count <= 0;

-- 5. check invalid fares
SELECT *
FROM railway_data
WHERE ticket_fare < 0;

-- 6.check cancellation values
SELECT DISTINCT cancellation
FROM railway_data;



-- 1. Total passengers
SELECT
    SUM(passenger_count) AS total_passengers
FROM railway_data;

-- 2. Total revenue
SELECT
    SUM(passenger_count * ticket_fare) AS total_revenue
FROM railway_data;

-- 3. Average fare
SELECT
    ROUND(AVG(ticket_fare),2) AS average_fare
FROM railway_data;

-- 4. Average delay
SELECT
    ROUND(AVG(delay_minutes),2) AS average_delay
FROM railway_data;

-- 5. Passengers by train
SELECT
    train_name,
    SUM(passenger_count) AS total_passengers
FROM railway_data
GROUP BY train_name
ORDER BY total_passengers DESC;

-- 6. Revenue by train
SELECT
    train_name,
    SUM(passenger_count * ticket_fare) AS total_revenue
FROM railway_data
GROUP BY train_name
ORDER BY total_revenue DESC;

-- 7. Passengers by route
SELECT
    source_station,
    destination_station,
    SUM(passenger_count) AS total_passengers
FROM railway_data
GROUP BY source_station, destination_station
ORDER BY total_passengers DESC;

-- 8. Revenue by route
SELECT
    source_station,
    destination_station,
    SUM(passenger_count * ticket_fare) AS total_revenue
FROM railway_data
GROUP BY source_station, destination_station
ORDER BY total_revenue DESC;

-- 9. Monthly passengers
SELECT
    YEAR(journey_date) AS year,
    MONTH(journey_date) AS month,
    SUM(passenger_count) AS passengers
FROM railway_data
GROUP BY YEAR(journey_date), MONTH(journey_date)
ORDER BY year, month;

-- 10. Average delay by train
SELECT
    train_name,
    ROUND(AVG(delay_minutes),2) AS average_delay
FROM railway_data
GROUP BY train_name
ORDER BY average_delay DESC;

-- 11. On-time percentage
SELECT
    train_name,
    ROUND(
        100.0 *
        SUM(CASE
            WHEN delay_minutes <= 5 THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS on_time_percentage
FROM railway_data
GROUP BY train_name;

-- 12. Cancellation rate
SELECT
    ROUND(
        100.0 *
        SUM(CASE
            WHEN cancellation = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate
FROM railway_data;







CREATE OR REPLACE VIEW railway_dashboard AS
SELECT
    journey_id,
    train_id,
    train_name,
    source_station,
    destination_station,
    journey_date,
    passenger_count,
    ticket_fare,
    passenger_count * ticket_fare AS revenue,
    scheduled_time,
    actual_time,
    delay_minutes,
    cancellation,
    train_type,

    CASE
        WHEN delay_minutes <= 5 THEN 'On Time'
        WHEN delay_minutes <= 15 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END AS performance

FROM railway_data;








SELECT
    CASE
        WHEN delay_minutes <= 5 THEN 'On Time'
        WHEN delay_minutes <= 15 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END AS performance,
    COUNT(*) AS total_journeys
FROM railway_data
GROUP BY performance;



SELECT cancellation,COUNT(*)AS total
FROM railway_data
GROUP   BY cancellation;




UPDATE railway_data
SET cancellation='YES'
WHERE Journey_id IN('J006','J013','J018');

SELECT cancellation,COUNT(*)AS total
FROM railway_data
GROUP BY cancellation;