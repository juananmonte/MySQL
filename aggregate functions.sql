/*----------AGGREGATE FUNCTIONS-------------*/

SELECT COUNT(*) AS number_of_invoices,
	SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

/*use many aggregate functions*/
SELECT 'After 1/1/2018' AS selection_date,
	COUNT(*) AS number_of_invoices,
ROUND(AVG(invoice_total), 2) AS avg_invoice_amt,
SUM(invoice_total) AS total_invoice_amt
FROM invoices
WHERE invoice_date > '2018-01-01';

/*HAVING and GROUP BY*/
SELECT vendor_id, ROUND(AVG(invoice_total), 2) AS average_invoice_amount
FROM invoices
GROUP BY vendor_id
HAVING AVG(invoice_total) > 2000 /*GROUP BY this condition*/
ORDER BY average_invoice_amount DESC;

/*number of invoices by vendor*/
SELECT vendor_id, COUNT(*) AS invoice_qty /*la cantidad de rows que aparecen por cada vendor*/
FROM invoices
GROUP BY vendor_id;

/*number of invoices and the average invoice amount for the vendors in each state and city*/
SELECT vendor_state, vendor_city, COUNT(*) AS invoice_qty, 
				  ROUND(AVG(invoice_total), 2) AS invoice_avg
FROM invoices JOIN vendors /*para obetener la info de las ciudades*/
	ON vendors.vendor_id =invoices.vendor_id
GROUP BY vendor_state, vendor_city
ORDER BY vendor_state, vendor_city;

/*aggregate functions and search (using having)*/
SELECT invoice_date, COUNT(*) AS invoice_qty, SUM(invoice_total) AS invoice_sum
FROM invoices
GROUP BY invoice_date
HAVING invoice_date BETWEEN '2018-05-01' AND '2018-05-31' /*this part could be a WHERE instead*/
		AND COUNT(*) > 1 /*but these two part must be in a HAVING*/
        AND SUM(invoice_total) > 100
ORDER BY invoice_date DESC;

/*----------WITH ROLLUP operator---------*/
SELECT vendor_id, COUNT(*) AS invoice_count, SUM(invoice_total) AS invoice_total
FROM invoices
GROUP BY vendor_id WITH ROLLUP; /*agrega un total por decir*/

/*-----GROUPING operator-----*/
SELECT IF(GROUPING(invoice_date) = 1, 'Grand totals', invoice_date) /*IF ( when doing GROUPING x is null (=1), then assign Grand_total)*/
	   AS invoice_date,
       IF(GROUPING(payment_date) = 1, 'Invoice date totals', payment_date)
	   AS payment_date,
	   SUM(invoice_total) AS invoice_total,
       SUM(invoice_total - credit_total - payment_total) AS balance_due
FROM invoices
WHERE invoice_date BETWEEN '2018-07-24' AND '2018-07-31'
GROUP BY invoice_date, payment_date WITH ROLLUP;

/*A query that displays only summary rows*/

SELECT  IF(GROUPING(invoice_date) = 1 , 'Grand totals', invoice_date) AS invoice_date,
		IF(GROUPING (payment_date) = 1 , 'Invoice date totals', payment_date) AS payment_date,
		SUM(invoice_total) AS invoice_total,
		SUM(invoice_total - credit_total - payment_total) AS balance_due
FROM invoices
WHERE invoice_date BETWEEN '2018-07-24' AND '2018-07- 31'
GROUP BY invoice_date, payment_date WITH ROLLUP
HAVING GROUPING(invoice_date) = 1 OR GROUPING(payment_date) = 1; 

/*---------AGGREGATE WINDOW------------*/

SELECT vendor_id, invoice_date, invoice_total, 
		SUM(invoice_total) OVER() AS total_invoices, /* no tan necesario*/
        SUM(invoice_total) OVER(PARTITION BY vendor_id) AS vendor_total 
FROM invoices
WHERE invoice_total > 5000


    
    