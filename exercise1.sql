
--EX1:
select NAME from CITY
where population > 120000 
and COUNTRYCODE = 'USA'
-- Ex2:
select * from CITY 
where COUNTRYCODE = 'JPN'
--Ex3
select CITY, STATE from STATION
--Ex4:

SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%' 
   OR CITY LIKE 'E%' 
   OR CITY LIKE 'I%' 
   OR CITY LIKE 'O%' 
   OR CITY LIKE 'U%'
   OR CITY LIKE 'a%' 
   OR CITY LIKE 'e%' 
   OR CITY LIKE 'i%' 
   OR CITY LIKE 'o%' 
   OR CITY LIKE 'u%'
ORDER BY CITY;
-- EX5
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%A'
    OR CITY LIKE '%E'
    OR CITY LIKE '%I'
    OR CITY LIKE '%O'
    OR CITY LIKE '%U'
    OR CITY LIKE '%a'
    OR CITY LIKE '%e'
    OR CITY LIKE '%i'
    OR CITY LIKE '%u'
    OR CITY LIKE '%o'
--EX6:
SELECT DISTINCT CITY
FROM STATION
WHERE NOT (CITY LIKE 'A%' 
   OR CITY LIKE 'E%' 
   OR CITY LIKE 'I%' 
   OR CITY LIKE 'O%' 
   OR CITY LIKE 'U%'
   OR CITY LIKE 'a%' 
   OR CITY LIKE 'e%' 
   OR CITY LIKE 'i%' 
   OR CITY LIKE 'o%' 
   OR CITY LIKE 'u%')
--EX7
select name from Employee
order by name
--EX8
select name from EMPLOYEE
where salary > 2000 and months < 10
--EX9
select product_id from Products
where low_fats = 'Y' and recyclable = 'Y'
--EX10:
SELECT name
FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;
--EX11:
select name, population, area from World
where area >= 3000000 or population >= 25000000
--EX12:
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;
--EX13
SELECT part, assembly_step FROM parts_assembly
where finish_date is NULL;
EX14:
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000;
EX15:
select advertising_channel from uber_advertising
where money_spent > 100000;
