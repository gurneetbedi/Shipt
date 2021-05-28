----Inserting into Supplier 
-- STEP 2
INSERT INTO TTY_SUPPLIER(
            SUPPLY_PK, 
            SUPPLY_NAME
            )
-- STEP 1
SELECT seq_supply_pk.NEXTVAL ,
        SUPPLIER_NAME
FROM (SELECT DISTINCT
           supplier_name
       FROM
           gb2388_shipt_stage
       WHERE
           supplier_name IS NOT NULL)
           
--STEP 3
SELECT * FROM TTY_SUPPLIER

----Inserting into Customer 
-- STEP-2
INSERT INTO TTY_CUSTOMER (customer_pk, customer_name)
-- STEP 1
SELECT DISTINCT CUSTOMER_PK, CUSTOMER_NAME
FROM GB2388_SHIPT_STAGE
WHERE CUSTOMER_PK IS NOT NULL
-- STEP 3 
SELECT COUNT(*)
FROM TTY_CUSTOMER



----Inserting into State
--STEP 2
INSERT INTO TTY_STATE(
        STATE_PK,
        NAME)
-- STEP 1
SELECT seq_state_pk.NEXTVAL ,
        STATE_Name
FROM (SELECT DISTINCT
           STATE_Name
       FROM
           gb2388_shipt_stage
       WHERE
           STATE_Name IS NOT NULL)
           

--STEP 3
SELECT COUNT(*) FROM TTY_STATE

----Inserting into County 
--STEP 2
INSERT INTO TTY_COUNTY(County_id, 
                        county_name,
                        STATE_FK
                        )
-- STEP 1
SELECT seq_county_pk.NEXTVAL,
        COUNTY_NAME,
        (SELECT STATE_PK
        FROM TTY_STATE 
        WHERE tty_state.state_name = data_1.state_name)state_pk
FROM    (SELECT DISTINCT county_name,
        state_name
        FROM GB2388_SHIPT_STAGE
        WHERE county_name IS NOT NULL) data_1
--STEP 3    
SELECT COUNT(*) FROM TTY_COUNTY



----Inserting into Delivery Status
    
    
--STEP 1
INSERT INTO TTY_DELIVERY_STATUS(DELIVERY_STATUS_PK , STATUS)
-- STEP 2
SELECT DISTINCT DELIVERY_STATUS_PK, DELIVERY_STATUS
FROM GB2388_SHIPT_STAGE
WHERE DELIVERY_STATUS_PK IS NOT NULL
--STEP 3
SELECT * FROM TTY_DELIVERY_STATUS


----Inserting into Delivery Person

--STEP 1
INSERT INTO TTY_DELIVERY_PERSON(PERSON_PK, FIRST_NAME, LAST_NAME, PHONE_NUMBER)

--STEP 2
SELECT DISTINCT PERSON_PK, FIRST_NAME, LAST_NAME, PHONE_NUMBER
FROM GB2388_SHIPT_STAGE
WHERE PERSON_PK IS NOT NULL

-- STEP 3
SELECT COUNT(*) FROM TTY_DELIVERY_PERSON


----Inserting into Order Status

--STEP 2
INSERT INTO TTY_ORDER_STATUS(ORDER_STATUS_PK,
            ORDER_STATUS)
-- STEP 1
SELECT seq_status_pk.nextval, 
    STATUS
    FROM(SELECT DISTINCT STATUS
    FROM GB2388_SHIPT_STAGE
    WHERE STATUS IS NOT NULL)
    
-- STEP 3
SELECT COUNT(*) FROM TTY_ORDER_STATUS


----Inserting into Order


-- STEP 2
INSERT INTO TTY_ORDER(ORDER_PK, ORDER_DATE, STATUS_FK, CUSTOMER_FK)
-- STEP 1
SELECT  ORDER_PK,
        ORDER_DATE,
        (SELECT ORDER_STATUS_PK
        FROM TTY_ORDER_STATUS 
        WHERE TTY_ORDER_STATUS.order_status = data_1.order_status)status_fk,
        (SELECT CUSTOMER_PK
        FROM TTY_CUSTOMER
        WHERE tty_customer.customer_name = data_1.customer_name) customer_fk 
FROM    (SELECT DISTINCT ORDER_PK, ORDER_DATE,
        status order_status, customer_name
        FROM GB2388_SHIPT_STAGE
        WHERE ORDER_PK IS NOT NULL) data_1
-- STEP 3
SELECT COUNT(*) FROM TTY_ORDER



----Inserting into Delivery 


-- STEP 2
INSERT INTO TTY_DELIVERY(DELIVERY_PK, PERSON_FK, DELIVERY_TIME, STATUS_FK, ORDER_FK)
-- STEP - 1
SELECT seq_delivery_pk.nextval,
       (SELECT person_pk
       FROM tty_delivery_person tdp
       WHERE tdp.first_name = data_1.first_name
       AND tdp.last_name = data_1.last_name
       AND tdp.phone_number = data_1.phone_number)person_fk,
       delivery_time,
       (SELECT DELIVERY_STATUS_PK
        FROM TTY_DELIVERY_STATUS tds
        WHERE tds.STATUS  = data_1.DELIVERY_STATUS ) status_fk,
       (SELECT order_pk 
       FROM tty_order tto
       WHERE tto.order_date = data_1.order_date)order_fk
FROM (SELECT DISTINCT first_name,last_name, phone_number, delivery_time, 
      DELIVERY_STATUS , order_date
      FROM GB2388_SHIPT_STAGE
      WHERE delivery_time IS NOT NULL)data_1
        
SELECT COUNT(*) FROM TTY_DELIVERY


DROP SEQUENCE seq_delivery_pk
CREATE SEQUENCE seq_delivery_pk

SELECT DISTINCT delivery_status FROM GB2388_SHIPT_STAGE
WHERE delivery_status IS NOT NULL

----Inserting into City

-- STEP 2
INSERT INTO TTY_CITY(City_pk, City_Name, County_fk)
-- STEP 1
SELECT seq_city_pk.nextval, 
        CITY_NAME,
        (SELECT COUNTY_PK
        FROM tty_county ttc
        WHERE ttc.county_name = data_1.county_name
        AND STATE_FK = (
        SELECT STATE_PK
        FROM TTY_STATE tts
        WHERE tts.state_name = data_1.state_name))COUNTY_FK
FROM    (SELECT DISTINCT CITY_NAME,
        county_name,
        state_name
        FROM GB2388_SHIPT_STAGE
        WHERE CITY_NAME IS NOT NULL)data_1
    
-- STEP 3

SELECT COUNT(*) FROM TTY_CITY




SELECT seq_county_pk.NEXTVAL,
        COUNTY_NAME,
        (SELECT STATE_PK
        FROM TTY_STATE 
        WHERE tty_state.state_name = data_1.state_name)state_pk
FROM    (SELECT DISTINCT county_name,
        state_name
        FROM GB2388_SHIPT_STAGE
        WHERE county_name IS NOT NULL) data_1



----Inserting into Discount Type

--STEP 2
INSERT INTO TTY_DISCOUNT_TYPE(DISCOUNT_PK,DISCOUNT_TYPE)
-- STEP 1
SELECT DISTINCT DISCOUNT_KIND_PK, DISCOUNT_TYPE
FROM GB2388_SHIPT_STAGE
WHERE DISCOUNT_KIND_PK IS NOT NULL
-- STEP 3
SELECT COUNT(*) FROM TTY_DISCOUNT_TYPE



----Inserting into Product


--STEP 2
INSERT INTO TTY_PRODUCT(PRODUCT_PK, PRODUCT_NAME, MANUFACTURED_DATE, PRICE, EXPIRY_DATE, WEIGHT, SUPPLIER_FK)

-- STEP 1
SELECT seq_product_pk.nextval,
       PRODUCT_NAME, 
       MANUFACTURED_DATE, 
       PRICE, 
       EXPIRY_DATE, 
       WEIGHT,
       (SELECT SUPPLY_PK
       FROM TTY_SUPPLIER tts
       WHERE tts.supply_name = data_1.supplier_name) SUPPLIER_FK
FROM (SELECT DISTINCT PRODUCT_NAME, 
       MANUFACTURED_DATE, 
       PRICE, 
       EXPIRY_DATE, 
       WEIGHT,
       SUPPLIER_NAME
       FROM GB2388_SHIPT_STAGE
      WHERE PRODUCT_NAME IS NOT NULL)data_1
-- STEP 3
SELECT COUNT(*) FROM TTY_PRODUCT


----Inserting into Discount Type

-- STEP 2
INSERT INTO TTY_DISCOUNT(DISCOUNT_PK, DISCOUNT_TYPE_FK, PERCENTAGE, START_DATE, END_DATE, PRODUCT_FK)
-- STEP 1
SELECT SEQ_DISCOUNT_PK.nextval,
       (SELECT DISTINCT DISCOUNT_PK
        FROM tty_discount_type tyd
        Where tyd.discount_type = data_1.discount_type)DISCOUNT_TYPE_FK,
       PERCENTAGE,
       START_DATE,
       END_DATE,
       (SELECT PRODUCT_pk
       FROM TTY_PRODUCT ttp
       WHERE ttp.product_name = data_1.product_name)PRODUCT_FK 
FROM  (SELECT DISTINCT DISCOUNT_PK,
       PERCENTAGE,
       START_DATE,
       END_DATE,
       product_name,
       discount_type
       FROM GB2388_SHIPT_STAGE
       WHERE PERCENTAGE IS NOT NULL
       ORDER BY DISCOUNT_PK ASC)data_1
-- STEP 3
SELECT * FROM TTY_DISCOUNT





CREATE SEQUENCE SEQ_DISCOUNT_PK


----Inserting into Product Detail 

--STEP 1
INSERT INTO TTY_PRODUCT_DETAIL(PRODUCT_PK, QUANTITY, PRICE, DISCOUNT_FK, PRODUCT_FK, ORDER_FK)
-- STEP 2
SELECT seq_PRODUCT_DETAIL_PK.nextval,
       QUANTITY, 
       PRICE , 
       (SELECT DISCOUNT_PK
       FROM TTY_DISCOUNT ttd
       WHERE ttd.percentage = data_1.percentage)DISCOUNT_FK, 
       (SELECT PRODUCT_PK
       FROM TTY_PRODUCT ttp
       WHERE ttp.product_name = data_1.product_name)PRODUCT_FK ,
       (SELECT ORDER_PK
       FROM tty_order tto
       WHERE tto.order_Date = data_1.order_date)ORDER_FK
FROM (SELECT DISTINCT QUANTITY, 
      price,
      percentage,
      product_name,
      order_date
      FROM GB2388_SHIPT_STAGE
      WHERE PRICE IS NOT NULL) DATA_1
      
-- STEP 3
SELECT COUNT(*) FROM TTY_PRODUCT_DETAIL



SELECT COUNT(DISTINCT(email)) FROM GB2388_SHIPT_STAGE
SELECT COUNT(DISTINCT(CUSTOMER_NAME))  FROM GB2388_shipt_stage


----Inserting into Communication


-- STEP 2
INSERT INTO TTY_COMMUNICATION(COMMUNICATION_PK, PHONE, EMAIL, SUPPLY_FK, CUSTOMER_FK)

-- STEP 1
    
select seq_communication_pk.nextval,
phone,email, supply_fk, customer_pk
from (
    select  
    phone,
    email,
    null supply_fk,
    customer_pk
from (
    select distinct customer_pk, phone, email
    from gb2388_shipt_stage
    WHERE PHONE IS NOT NULL AND
    CUSTOMER_PK IS NOT NULL)data_1
union all
select   phone,
         email,
        (SELECT SUPPLY_PK
        FROM TTY_SUPPLIER tts
        WHERE tts.SUPPLY_NAME = DATA_1.supplier_name)supply_fk ,
        null customer_fk
FROM  (
select distinct supplier_name, email, customer_pk , phone
from gb2388_shipt_stage
WHERE PHONE IS NOT NULL
AND supplier_name IS NOT NULL)data_1)

--- STEP 3

SELECT COUNT(*) FROM TTY_COMMUNICATION

DROP SEQUENCE seq_communication_pk
CREATE SEQUENCE seq_communication_pk

--STEP 1
INSERT INTO TTY_COMMUNICATION(communication_pk, SUPPLY_FK)
-- STEP 2
SELECT seq_communication_pk.nextval,
      (SELECT SUPPLY_PK
       FROM TTY_SUPPLIER tts
       WHERE tts.supply_name = data_1.supplier_name) SUPPLY_FK
    
FROM(SELECT supplier_name
    FROM GB2388_SHIPT_STAGE)data_1

-- STEP 3
SELECT DISTINCT SUPPLY_FK
FROM TTY_COMMUNICATION
WHERE SUPPLY_FK IS NOT NULL


----Inserting into Location

--STEP 2
INSERT INTO TTY_LOCATION(LOCATION_PK, Street_address, postal_code, city_fk, supply_fk, customer_fk)
--STEP 1
SELECT seq_location_pk.nextval,
       STREET_ADDRESS,
       POSTAL_CODE,
       (SELECT CITY_PK
       FROM TTY_CITY ttc
       WHERE ttc.city_name = data_1.city_name
       AND COUNTY_FK = (
       SELECT COUNTY_PK
       FROM tty_county ttc
       WHERE ttc.county_name = data_1.county_name
        AND STATE_FK = (
       SELECT STATE_PK
       FROM TTY_STATE tts
       WHERE tts.state_name = data_1.state_name)
       ))CITY_FK,
       (SELECT supply_pk
       FROM tty_supplier tts
        WHERE tts.supply_name = data_1.supplier_name)supply_fk,
       customer_pk
FROM(SELECT DISTINCT STREET_ADDRESS, 
    POSTAL_CODE,
    CITY_NAME,
    SUPPLIER_NAME,
    CUSTOMER_pk,
    county_name,
    state_name
    FROM GB2388_SHIPT_STAGE
    WHERE STREET_ADDRESS IS NOT NULL)data_1
-- STEP 3    
SELECT COUNT(*) FROM TTY_LOCATION
    
SELECT COUNT(DISTINCT(STREET_ADDRESS))
FROM GB2388_SHIPT_STAGE



SELECT * FROM TTY_DELIVERY

