-- Uppgift 1
CREATE TABLE successful_mission AS
SELECT *
FROM moon_mission
WHERE outcome = 'Successful';

-- Uppgift 2
AlTER TABLE successful_mission
    MODIFY COLUMN mission_id INT PRIMARY KEY AUTO_INCREMENT;

-- Uppgift 3
UPDATE moon_mission
SET operator = TRIM(REPLACE(operator, ' ', ''));

UPDATE successful_mission
SET operator = TRIM(REPLACE(operator, ' ', ''));

SELECT operator
FROM moon_mission;
SELECT operator
FROM successful_mission;

-- Uppgift 4
DELETE
FROM successful_mission
WHERE YEAR(launch_date) >= 2010;

-- Uppgift 5
SELECT *,
       CONCAT(first_name, ' ', last_name) AS name,
       CASE
           WHEN SUBSTRING(ssn, -2, 1) % 2 = 0 THEN 'female'
           ELSE 'male'
           END                            AS gender
FROM account;

-- Uppgift 6
DELETE
FROM account
WHERE SUBSTRING(ssn, -2, 1) % 2 = 0
  AND SUBSTRING(ssn, 1, 2) < '70';

-- Uppgift 7
SELECT CASE
           WHEN SUBSTRING(ssn, -2, 1) % 2 = 0 THEN 'female'
           ELSE 'male'
           END                                                                     AS gender,
       AVG(YEAR(CURDATE()) - CAST(CONCAT('19', SUBSTRING(ssn, 1, 2)) AS UNSIGNED)) AS average_age
FROM account
GROUP BY gender;

