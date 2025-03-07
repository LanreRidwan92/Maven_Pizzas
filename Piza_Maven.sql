SELECT * FROM pissa_db.pizza_types;

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
									-- CHECKING DUPLICATE VALUES IN THE TABLES BY CREATING DUOLICATE TABLES -- 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- ord_det --
 
 CREATE TABLE order_det
 LIKE order_details;
 
 INSERT INTO order_det
 SELECT * 
 FROM order_details;
 
-- CHECKING DUPLICATE VALUES --

SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY order_details_id, order_id, pizza_id, quantity) AS Row_Num
 FROM order_det
LIMIT 10 ;

WITH CTE_ORD_DUP 
AS 
	(
    SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY order_details_id, order_id, pizza_id, quantity) AS Row_Num
 FROM order_det
    )
SELECT *
FROM CTE_ORD_DUP
WHERE Row_Num > 1
LIMIT 20;
 

SELECT *
FROM pizza_types
LIMIT 20;
 
-- PIZZA TYPE --
 
CREATE TABLE Pizza_Type
LIKE pizza_types;
 
INSERT INTO Pizza_type
SELECT * 
FROM pizza_types;
 
-- CHECKING DUPLICATE VALUES IN PIZZA TYPE TABLE --

SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY pizza_type_id, `name`, category, ingredients) AS Row_Num
FROM Pizza_type
	LIMIT 10 ;

WITH CTE_PIZ_DUP 
AS 
	(
    SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY pizza_type_id, `name`, category, ingredients) AS Row_Num
FROM Pizza_type
    )
SELECT *
FROM CTE_PIZ_DUP
WHERE Row_Num > 1
LIMIT 20;


-- ORDER TABLE --
 
CREATE TABLE Order_Dup
LIKE Orders;
 
INSERT INTO Order_Dup
SELECT * 
FROM orders;
 
-- CHECKING DUPLICATE VALUES IN ORDER TYPE TABLE --

SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY order_id, `date`, `time`) AS Row_Num
FROM Order_Dup
	LIMIT 10 ;

WITH CTE_ORDER_DUP 
AS 
	(
    SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY order_id, `date`, `time`) AS Row_Num
FROM Order_Dup
    )
SELECT *
FROM CTE_ORDER_DUP
WHERE Row_Num > 1
LIMIT 20;


-- PIZZA TABLE --
 
CREATE TABLE Piza_Dup
LIKE pizzas;
 
INSERT INTO Piza_Dup
SELECT * 
FROM pizzas;
 
-- CHECKING DUPLICATE VALUES IN PIZZA TABLE --

SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY pizza_id, pizza_type_id, size, price) AS Row_Num
FROM Piza_Dup
	LIMIT 10 ;

WITH CTE_PIZA_DUP 
AS 
	(
    SELECT *,
	ROW_NUMBER() OVER 
    (PARTITION BY pizza_id, pizza_type_id, size, price) AS Row_Num
FROM Piza_Dup
    )
SELECT *
FROM CTE_PIZA_DUP
WHERE Row_Num > 1
LIMIT 20;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                      -- CHECKING THE DISTINCT ORDER --
------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TOTAL ORDERS --

SELECT COUNT(order_details_id)
FROM order_det
LIMIT 10;

-- DISTINCT ORDERS --

SELECT DISTINCT COUNT(order_details_id)
FROM order_det;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
											-- CHANGE THE DATE AND TIME COLUMNS FROM TEXT TO NORMAL TYPES --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE order_dup
MODIFY COLUMN `date` DATE;

ALTER TABLE order_dup
MODIFY COLUMN `time` TIME;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                       -- CREATE SESSION DAY, MONTH AND DAY COLUMNS --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE DAY SESSION COLUMN--

ALTER TABLE order_dup
ADD COLUMN day_sesion TEXT;

-- POPULATE THE NEW COLUMNS --

SELECT *,
CASE
	WHEN `time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN `time` BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END AS session
FROM order_dup;


UPDATE order_dup
SET day_sesion = (
	CASE
    WHEN `time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN `time` BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    ELSE 'Evening'
    END
    );


-- CREATE MONTH COLUMN --

ALTER TABLE order_dup
ADD COLUMN `Month`TEXT;

SELECT DISTINCT MONTHNAME(date)
FROM order_dup;

UPDATE order_dup
SET `Month` = MONTHNAME(date);

-- CREATE DAY COLUMN --

ALTER TABLE order_dup
ADD COLUMN `day`TEXT;

SELECT DISTINCT DAYNAME(date)
FROM order_dup;

UPDATE order_dup
SET `day` = DAYNAME(date);

SELECT *
FROM order_dup
LIMIT 5;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                       -- CHECK THE DIFFERENCE CATEGORY --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT(`name`)
FROM pizza_type
LIMIT 10;

SELECT category, 
	COUNT(category) AS Total_Category
FROM pizza_type
	GROUP BY category
    LIMIT 10;

SELECT `name`, 
	COUNT(`name`) AS Total_Name
FROM pizza_type
	GROUP BY `name`
    LIMIT 10;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                  --  RENAME PIZZA SIZE'S VALUES FROM ACRONYMS TO WORDS --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE piza_dup
SET size = 'Small'
WHERE size = 'S';

UPDATE piza_dup
SET size = 'Medium'
WHERE size = 'M';

UPDATE piza_dup
SET size = 'Large'
WHERE size = 'L';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
														-- JOIN THE TABLES TOGETHER --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * 
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
LIMIT 50;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- TOTAL NUMBER OF CUSTMER WE HAVE IN EACH DAY --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `day`,
	COUNT(order_id) AS total_daily_order
FROM order_dup
	GROUP BY `day`
	ORDER BY total_daily_order DESC;
    
-- TOTAL CUSTOMERS -- 
 
SELECT COUNT(order_details_id)
FROM order_det;

-- TOTAL CUSTOMERS IN A DAY -- 

SELECT DISTINCT `day`,
	COUNT(order_details_id) AS total_customer_daily
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	GROUP BY `day`
	ORDER BY total_customer_daily DESC;


-- ORDER BY THE TIME OF THE DAY--

SELECT DISTINCT `day_sesion`,
	COUNT(order_details_id) AS total_order_hours
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	GROUP BY `day_sesion`
	ORDER BY total_order_hours DESC;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- MOST ORDERED PIZZAS --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT COUNT(`name`)
FROM pizza_type;

SELECT DISTINCT(`name`),
	COUNT(order_details_id) AS total_pizza_type_orders
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
    GROUP BY `name`
    ORDER BY total_pizza_type_orders DESC;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- MONTHLY SALES BY REVENUE --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(price)
FROM piza_dup;

SELECT DISTINCT `Month`, 
	SUM(price) AS total_monthly_sales
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
    GROUP BY `Month`
    ORDER BY total_monthly_sales DESC;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- REVENUE GENERATED BY TOP FIVE PERFORMING PIZZAS --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `name`, 
	SUM(price) AS total_sales
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
    GROUP BY `name`
    ORDER BY total_sales DESC
    LIMIT 5;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- REVENUE GENERATED BY THE LEAST PERFOMING PIZZAS --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `name`, 
	SUM(price) AS total_sales
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
    GROUP BY `name`
    ORDER BY total_sales ASC
    LIMIT 5;










SELECT * 
FROM order_det AS od
	LEFT JOIN order_dup AS du
    ON od.order_id = du.order_id
	LEFT JOIN piza_dup AS pd
    ON od.pizza_id = pd.pizza_id
    LEFT JOIN pizza_type AS pt
    ON pd.pizza_type_id = pt.pizza_type_id
LIMIT 50;




SELECT *
FROM piza_dup
LIMIT 10;
