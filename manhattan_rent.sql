SELECT * FROM world_layoffs.manhattan_rent;

-- how many units are there --

SELECT COUNT('rental_id')  AS total_units
From manhattan_rent;

-- How many different Towns have had sales --

SELECT COUNT(DISTINCT neighborhood) AS number_of_neighborhoods
 from manhattan_rent
 ;
 
 -- Number of Units in each neighborhood
 
 Select neighborhood, COUNT(rental_id) AS number_of_units
 From manhattan_rent
 Group by neighborhood
 ;

-- Different Property Types -- 

SELECT bedrooms, COUNT(bedrooms)
 from manhattan_rent
Group by bedrooms
ORDER BY bedrooms
;

-- Is 0 bedrooms a studio? What is half a bedroom? -- 

-- Age of the buildings -- 

-- Are there errors with the building ages of 0 or are they new buildings? -- 

SELECT building_age_yrs, COUNT(rental_id)
 from manhattan_rent
Group by building_age_yrs
Order by building_age_yrs
;

-- Average rent price by neighborhood -- 

SELECT neighborhood, ROUND(AVG(rent),0) AS Average_rent
From manhattan_rent
group by neighborhood
order by AVG(rent) 
;

-- Rent by minutes from subway --

SELECT min_to_subway, ROUND(AVG(rent),0) AS Average_rent
From manhattan_rent
group by min_to_subway
order by min_to_subway 
;

-- Rent by distance from subway grouped --

SELECT ROUND(AVG(rent),0) AS Average_rent,
CASE
	WHEN min_to_subway <= 5 THEN '5 or less'
    WHEN min_to_subway BETWEEN 6 And 10 Then '6-10 mins'
    WHEN min_to_subway BETWEEN 11 AND 15 Then '11-15 mins'
    WHEN min_to_subway BETWEEN 15 AND 20 THEN '16-20 mins'
    WHEN min_to_subway > 20 THEN 'More than 20 mins'
END AS Minutes_from_subway
From manhattan_rent
GROUP BY minutes_from_subway
Order by minutes_from_subway
;

SELECT 
    neighborhood,
    CASE
        WHEN min_to_subway <= 5 THEN '5 or less'
        WHEN min_to_subway BETWEEN 6 AND 10 THEN '6-10 mins'
        WHEN min_to_subway BETWEEN 11 AND 15 THEN '11-15 mins'
        WHEN min_to_subway BETWEEN 16 AND 20 THEN '16-20 mins'
        ELSE 'More than 20 mins'
    END AS Minutes_from_subway,
    ROUND(AVG(rent),0) AS Average_Rent
FROM manhattan_rent
GROUP BY neighborhood, 
    CASE
        WHEN min_to_subway <= 5 THEN '5 or less'
        WHEN min_to_subway BETWEEN 6 AND 10 THEN '6-10 mins'
        WHEN min_to_subway BETWEEN 11 AND 15 THEN '11-15 mins'
        WHEN min_to_subway BETWEEN 16 AND 20 THEN '16-20 mins'
        ELSE 'More than 20 mins'
    END
ORDER BY neighborhood, Minutes_from_subway
;

--  Rent by Neighborhood, Number of Bedrooms, and minutes from Subway  -- 

SELECT 
    neighborhood, bedrooms,
    CASE
        WHEN min_to_subway <= 5 THEN '5 or less'
        WHEN min_to_subway BETWEEN 6 AND 10 THEN '6-10 mins'
        WHEN min_to_subway BETWEEN 11 AND 15 THEN '11-15 mins'
        WHEN min_to_subway BETWEEN 16 AND 20 THEN '16-20 mins'
        ELSE 'More than 20 mins'
    END AS Minutes_from_subway,
    ROUND(AVG(rent),0) AS Average_Rent
FROM manhattan_rent
GROUP BY neighborhood, bedrooms,
    CASE
        WHEN min_to_subway <= 5 THEN '5 or less'
        WHEN min_to_subway BETWEEN 6 AND 10 THEN '6-10 mins'
        WHEN min_to_subway BETWEEN 11 AND 15 THEN '11-15 mins'
        WHEN min_to_subway BETWEEN 16 AND 20 THEN '16-20 mins'
        ELSE 'More than 20 mins'
    END
ORDER BY neighborhood, bedrooms, Minutes_from_subway;



-- Average Rent by Apartment size -- 

SELECT ROUND(AVG(rent),0) AS Average_rent,
CASE
	WHEN size_sqft < 500 THEN 'small'
    WHEN size_sqft BETWEEN 500 And 1000 Then 'medium'
    WHEN size_sqft BETWEEN 1000 AND 1500 Then 'Large'
    WHEN size_sqft > 1500 THEN 'extra large'
END AS Apartment_size
From manhattan_rent
GROUP BY apartment_size
Order by AVG(rent)
;

-- Square footage Effects on Rent by Neighborhood -- 

SELECT 
    neighborhood,
    CASE
        WHEN size_sqft <= 500 THEN 'Small'
        WHEN size_sqft BETWEEN 501 AND 1000 THEN 'Medium'
        WHEN size_sqft BETWEEN 1001 AND 1500 THEN 'Large'
        ELSE 'Extra Large'
    END AS Square_feet,
    ROUND(AVG(rent),0) AS Average_Rent
FROM manhattan_rent
GROUP BY neighborhood, 
    CASE
        WHEN size_sqft <= 500 THEN 'Small'
        WHEN size_sqft BETWEEN 501 AND 1000 THEN 'Medium'
        WHEN size_sqft BETWEEN 1001 AND 1500 THEN 'Large'
        ELSE 'Extra Large'
    END
ORDER BY neighborhood, square_feet
;

-- Rent by Apartment Size, Neighborhood, and Number of Bedrooms -- 

SELECT 
    neighborhood, bedrooms,
    CASE
        WHEN size_sqft <= 500 THEN 'Small'
        WHEN size_sqft BETWEEN 501 AND 1000 THEN 'Medium'
        WHEN size_sqft BETWEEN 1001 AND 1500 THEN 'Large'
        ELSE 'Extra Large'
    END AS Square_feet,
    ROUND(AVG(rent),0) AS Average_Rent
FROM manhattan_rent
GROUP BY neighborhood, bedrooms,
    CASE
        WHEN size_sqft <= 500 THEN 'Small'
        WHEN size_sqft BETWEEN 501 AND 1000 THEN 'Medium'
        WHEN size_sqft BETWEEN 1001 AND 1500 THEN 'Large'
        ELSE 'Extra Large'
    END
ORDER BY neighborhood, bedrooms, square_feet
;

-- Washer and Dryer Effects on Rent -- 

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_washer_dryer = 1 THEN 'YES'
    WHEN has_washer_dryer = 0 THEN 'NO'
END AS Washer_and_dryer
From manhattan_rent
Group by washer_and_dryer
;

-- Rent with/without Washer and Dryer by Neighborhood -- 

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
  ROUND(AVG(CASE WHEN has_washer_dryer = 0 THEN rent END),0) AS no_washer_dryer
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and Bedrooms with/without a washer and dryer --

SELECT
  neighborhood,bedrooms,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
  ROUND(AVG(CASE WHEN has_washer_dryer = 0 THEN rent END),0) AS no_washer_dryer
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;


-- Doorman effects on Rent -- 

SELECT ROUND(AVG(rent),0) As Average_Rent,
CASE
	WHEN has_doorman = 1 THEN 'YES'
    WHEN has_doorman = 0 THEN 'NO'
END AS Doorman
From manhattan_rent
Group by Doorman
;


-- Rent with/without Doorman by neighborhood--

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_doorman = 0 THEN rent END),0) AS no_doorman
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and Bedrooms with/without a Doorman --

SELECT
  neighborhood, bedrooms,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_doorman = 0 THEN rent END),0) AS no_doorman
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;

-- Elevator Effects on Rent

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_elevator = 1 THEN 'YES'
    WHEN has_elevator = 0 THEN 'NO'
END AS Elevator
From manhattan_rent
Group by Elevator
;


-- Rent with/without an Elevator by Neighborhood -- 

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator,
  ROUND(AVG(CASE WHEN has_elevator = 0 THEN rent END),0) AS no_elevator
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and Bedrooms with/without an Elevator --

SELECT
  neighborhood, bedrooms,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator,
  ROUND(AVG(CASE WHEN has_elevator = 0 THEN rent END),0) AS no_elevator
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;

-- Patio Effects on Rent --

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_patio = 1 THEN 'YES'
    WHEN has_patio = 0 THEN 'NO'
END AS Patio
From manhattan_rent
Group by Patio
;

-- Rent with/without a Patio by Neighborhood -- 

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
  ROUND(AVG(CASE WHEN has_patio = 0 THEN rent END),0) AS no_patio
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and Bedrooms with/without a patio--

SELECT
  neighborhood,bedrooms,
  ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
  ROUND(AVG(CASE WHEN has_patio = 0 THEN rent END),0) AS no_patio
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;


-- Effects of having a Gym on Rent -- 

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_gym = 1 THEN 'YES'
    WHEN has_gym = 0 THEN 'NO'
END AS Gym
From manhattan_rent
Group by Gym
;


-- Rent with/without a Gym by Neighborhood--

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym,
  ROUND(AVG(CASE WHEN has_dishwasher = 0 THEN rent END),0) AS no_gym
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and Bedrooms with/without a gym --

SELECT
  neighborhood, bedrooms,
  ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym,
  ROUND(AVG(CASE WHEN has_dishwasher = 0 THEN rent END),0) AS no_gym
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;

-- Effects of having a Roofdeck on Rent --

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_roofdeck = 1 THEN 'YES'
    WHEN has_roofdeck = 0 THEN 'NO'
END AS Rooftop
From manhattan_rent
Group by rooftop
;


-- Rent with/without a Roofdeck by Neighborhood-- 

SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_roofdeck = 0 THEN rent END),0) AS no_roofdeck
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and  bedrooms for Roofdeck/No Roofdeck

SELECT
  neighborhood, bedrooms,
  ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_roofdeck = 0 THEN rent END),0) AS no_roofdeck
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;

-- Effects of Dishwashers on Rent -- 

SELECT ROUND(AVG(rent),0) AS Average_Rent,
CASE
	WHEN has_dishwasher = 1 THEN 'YES'
    WHEN has_dishwasher = 0 THEN 'NO'
END AS Dishwasher
From manhattan_rent
Group by Dishwasher
;

-- Rent for dishwasher/no dishwasher by neighborhood -- 
SELECT
  neighborhood,
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
  ROUND(AVG(CASE WHEN has_dishwasher = 0 THEN rent END),0) AS no_dishwasher
FROM manhattan_rent
GROUP BY neighborhood
Order by neighborhood
;

-- Rent by Neighborhood and # of Bedrooms w/without Dishwasher -- 

SELECT
  neighborhood, bedrooms,
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
  ROUND(AVG(CASE WHEN has_dishwasher = 0 THEN rent END),0) AS no_dishwasher
FROM manhattan_rent
GROUP BY neighborhood, bedrooms
Order by neighborhood, bedrooms
;

 -- Options for Studios in Manhattan --
 
 SELECT
  neighborhood, ROUND(AVG(rent),0) AS Average_rent,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
   ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator, 
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
 ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
   ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym
FROM manhattan_rent
WHERE bedrooms < 1
GROUP BY neighborhood
Order by neighborhood
;

-- Options for 1 Bedroom Apartments in Manhattan --

 SELECT
  neighborhood, ROUND(AVG(rent),0) AS Average_rent,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
   ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator, 
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
 ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
   ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym
FROM manhattan_rent
WHERE bedrooms = 1
GROUP BY neighborhood
Order by neighborhood
;

-- Options for 2 Bedroom Aparments in Manhattan -- 

 SELECT
  neighborhood, ROUND(AVG(rent),0) AS Average_rent,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
   ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator, 
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
 ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
   ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym
FROM manhattan_rent
WHERE bedrooms  = 2
GROUP BY neighborhood
Order by neighborhood
;

-- Options for 3 Bedroom Apartments in Manhattan --

 SELECT
  neighborhood, ROUND(AVG(rent),0) AS Average_rent,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
   ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator, 
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
 ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
   ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym
FROM manhattan_rent
WHERE bedrooms = 3
GROUP BY neighborhood
Order by neighborhood
;

-- Options for 4 or more Bedroom Apartments in Manhattan --

 SELECT
  neighborhood, ROUND(AVG(rent),0) AS Average_rent,
  ROUND(AVG(CASE WHEN has_washer_dryer = 1 THEN rent END),0) AS With_washer_dryer,
   ROUND(AVG(CASE WHEN has_roofdeck = 1 THEN rent END),0) AS With_roofdeck,
  ROUND(AVG(CASE WHEN has_doorman = 1 THEN rent END),0) AS With_doorman,
  ROUND(AVG(CASE WHEN has_elevator = 1 THEN rent END),0) AS With_elevator, 
  ROUND(AVG(CASE WHEN has_dishwasher = 1 THEN rent END),0) AS With_dishwasher,
 ROUND(AVG(CASE WHEN has_patio = 1 THEN rent END),0) AS With_patio,
   ROUND(AVG(CASE WHEN has_gym = 1 THEN rent END),0) AS With_gym
FROM manhattan_rent
WHERE bedrooms >= 4
GROUP BY neighborhood
Order by neighborhood
;