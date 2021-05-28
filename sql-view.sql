Appendix - SQL Views
--------------Ranking States Based On the number of stores in the state-----------
CREATE VIEW RANK_OF_STATE
AS
SELECT *
FROM (SELECT tts.state_name state_name,
RANK() OVER (ORDER BY COUNT(SUPPLY_NAME) DESC)
AS RANK_OF_STATE,
COUNT(SUPPLY_NAME) AS NUMBER_OF_SUPPLIERS
FROM TTY_LOCATION ttl
JOIN TTY_CITY ttc
ON ttc.city_pk = ttl.city_fk
JOIN TTY_SUPPLIER tts
ON ttl.supply_fk = tts.supply_pk
JOIN TTY_COUNTY tco
ON ttc.county_fk = tco.county_pk
JOIN TTY_STATE tts ON
tco.state_fk = tts.state_pk
WHERE tts.supply_name IS NOT NULL
AND TTC.city_name IS NOT NULL
GROUP BY tts.state_name)
---------------------------Cities With More Than 1 customer----------------------------
CREATE VIEW CITY_WITH_NUMBER_OF_CUSTOMER
AS
SELECT *
FROM
(SELECT ttc.city_name city_name,
COUNT(Customer_Name) AS NUMBER_OF_Customer
FROM TTY_LOCATION ttl
JOIN TTY_CITY ttc
ON ttc.city_pk = ttl.city_fk
JOIN TTY_Customer tyc
ON ttl.customer_fk = tyc.customer_pk
WHERE tyc.customer_name IS NOT NULL
AND ttc.city_name IS NOT NULL
GROUP BY ttc.city_name
HAVING COUNT(Customer_Name) > 1
ORDER BY COUNT(Customer_Name) DESC
)
-----------This view shows the product and the discount on the product-------------
CREATE VIEW PRODUCT_DISCOUNT
AS
WITH pdc AS
(SELECT
PRODUCT_PK,
PRODUCT_NAME,
PRICE
FROM TTY_PRODUCT),
dsc AS
(SELECT
PERCENTAGE,
START_DATE,
END_DATE,
discount_type_fk,
product_fk
FROM TTY_DISCOUNT),
dst AS
(SELECT
DISCOUNT_TYPE,
DISCOUNT_PK
FROM TTY_DISCOUNT_TYPE)
SELECT PRODUCT_NAME,
PRICE,
PERCENTAGE,
DISCOUNT_TYPE
FROM pdc, dsc, dst
WHERE dst.discount_pk = dsc.discount_type_fk
AND dsc.product_fk = pdc.product_pk
-----------Create View which shows the status of all the current orders------------
CREATE VIEW STATUS_OF_ORDER
AS
SELECT
*
FROM
(SELECT ORDER_STATUS,
COUNT (ORDER_STATUS) AS NUMBER_OF_ORDERS
FROM TTY_ORDER tto
JOIN TTY_CUSTOMER ttc
ON tto.customer_fk = ttc.customer_pk
JOIN TTY_ORDER_STATUS tos
ON tto.status_fk = tos.ORDER_STATUS_PK
GROUP BY ORDER_STATUS)
-------------------Supplier and the product exclusively sold by them-----------------
CREATE VIEW SUPPLIER_SPECALITY
AS
SELECT * FROM
(SELECT SUPPLY_NAME, PRODUCT_NAME
FROM TTY_SUPPLIER tts
JOIN TTY_PRODUCT ttp
ON tts.supply_pk = ttp.supplier_fk)