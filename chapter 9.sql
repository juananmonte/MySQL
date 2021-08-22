/*------------CAPITULO 9: How to use functions----------------*/

/*---------STRINGS-----------*/

/* CONCAT; UNITE THEM*/
SELECT vendor_name, CONCAT_WS(', ', vendor_contact_last_name, vendor_contact_first_name) AS contact_name,
					RIGHT(vendor_phone, 9) AS phone
FROM vendors
WHERE LEFT (vendor_phone, 4) = '(559'
ORDER BY contact_name;

/* look at the ex database. the string_ sample table*/


/*Sorted by the emp_id column implicitly cast as an integer*/
SELECT *
FROM string_sample
ORDER BY emp_id + 0;

/*Sorted by the emp_id column after it has been padded with leading zeros*/
/*ESTO ES MAS ESTETICA QUE OTRA COSA*/
SELECT LPAD(emp_id, 2, '0') AS emp_id, emp_name
FROM string_sample
ORDER BY emp_id;

/*parse a string:HAVING TWO OR MORE VALUES STORED IN THE SAME STRING and separating them*/
SELECT emp_name, SUBSTRING_INDEX(emp_name, ' ', 1) AS first_name, SUBSTRING_INDEX(emp_name, ' ', -1) AS last_name /*empiza desde el uno (o -1) hasta encontrar el espacio*/
FROM string_sample;

/*another way*/

SELECT emp_name,
				SUBSTRING(emp_name, 1, LOCATE('  ', 1, emp_name) - 1) AS first_name, 
				SUBSTRING(emp_name, LOCATE('  ', 1, emp_name) + 1) AS last_name
FROM string_sample;


/*How to use the LOCATE function to find a character in a string*/

/*esto NO DA LAS CANTIDADES DE ESPACIO ENTRE PALABRAS.. DA LA POSICION en la que aparece el espacio*/
SELECT emp_name, LOCATE(' ', emp_name) AS first_spaces, LOCATE(' ', emp_name, LOCATE(' ', emp_name)+1) AS second_space
FROM string_sample; 

/*----------NUMBERIC DATA-----------*/

/*How to search for approximate values*/

SELECT *
FROM float_sample
WHERE float_value BETWEEN 0.99 AND 1.01;

/*round values*/
SELECT ROUND(float_value, 2)
FROM float_sample;

/*----------date/time data-----------*/
SELECT *
FROM date_sample
WHERE start_date >= '2018-02-28' AND start_date < '2018-03-01';

/*Search for month, day, and year integers*/

SELECT *
FROM date_sample
WHERE MONTH(start_date) = 2 AND
	  DAYOFMONTH(start_date) = 28 AND
      YEAR(start_date) = 2018;

/*Search for a formatted/specific date*/

SELECT *
FROM date_sample
WHERE DATE_FORMAT(start_date, '%m-%d-%Y') = '02-28-2018';

/*Search for a range of times*/

SELECT * 
FROM date_sample
WHERE EXTRACT(HOUR_MINUTE FROM start_date) BETWEEN 900 AND 1200 /*horas se ponen de forma militar*/



/*----------OTHER FUNCTIONS---------------*/

/*********CASE*******/
/* SYNTAX 
CASE input_expression
END
WHEN when_expression_ l THEN result_expression_ l
[WHEN when_ expression_ 2 THEN result_expression_ 2] •••
[ELSE else_ result_expression] */

SELECT invoice_number, terms_id,
	CASE terms_id
		WHEN 1 THEN 'Net due 10 days'
        WHEN 2 THEN 'Net due 20 days'
        WHEN 3 THEN 'Net due 30 days'
        WHEN 4 THEN 'Net due 60 days'
        WHEN 5 THEN 'Net due 90 days'
	END AS terms
FROM invoices 

/*****SEARCHED CASE FUNCTION******/
/*syntax 
CASE
END
WHEN conditional_expression_ l THEN result_expression_ l
[WHEN conditional_ expression_ 2 THEN result_expression_ 2] •••
[ELSE else_ result_expression] */

/* search within a condition*/
SELECT invoice_number, invoice_total, invoice_date, invoice_due_date,
CASE
	WHEN DATEDIFF(NOW(), invoice_due_date) > 30
		THEN 'Over 30 days past due'
	WHEN DATEDIFF(NOW(), invoice_due_date) > 0
		THEN '1 to 30 days past due'
	ELSE 'Current' 
END AS invoice_status
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

/* IF funcion */

/*SYNTAX
IF(test_expression, if_ true_expression, else_expression)*/

SELECT vendor_name,
		IF(vendor_city = 'Fresno', 'Yes', 'No') AS is_city_fresno
FROM vendors;

/*******BUSCAR NULLS*********/
/*    IF NULL   */
/*SYNTAX
IFNULL(test_expression, replacement_value )*/

SELECT payment _date,
		IFNULL(payment_date, 'No Payment') AS new date
FROM invoices;

/*COALESCE (LO MISMO) */
SELECT payment _date,
		COALESCE(payment_date, 'No Payment' ) AS new_date
FROM invoices; 

/*---------A statement that uses the REGEXP_INSTR function-----------*/
SELECT DISTINCT vendor_city, REGEXP_INSTR(vendor_city, ' ') AS space_index
FROM vendors
WHERE REGEXP_INSTR(vendor_city, ' ') > 0
ORDER BY vendor_city; 

SELECT vendor_city, REGEXP_SUBSTR(vendor_city, '^SAN|LOS') AS city_match
FROM vendors
WHERE REGEXP_SUBSTR(vendor_city, '^SAN|LOS') IS NOT NULL;

/*REPLACE the */
SELECT vendor_name, vendor_address1,
		REGEXP_REPLACE(vendor_address1, 'STREET', 'St') AS new_address1
FROM Vendors
WHERE REGEXP_LIKE(vendor_address1, 'STREET'); /*use regex_like*/

/*A query that uses the ROW_NUMBER function*/

SELECT ROW_NUMBER() OVER(ORDER BY vendor_name) AS 'row_number', vendor_name
FROM vendors

