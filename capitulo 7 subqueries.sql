/*-------------SUBQUERIES-------------*/


/* 4 WAYS TO MAKE A SUBQUERY 

1. In a WHERE clause as a *search* condition
2. In a HAVING clause as a *search* condition
3. In the FROM clause as a *table* specification
4. In the SELECT clause as a *column* specification*/

SELECT	invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total >
	(SELECT AVG(invoice_total)
     FROM invoices)
ORDER BY invoice_total;


/* JOIN or SUBQUERY*/

/*---JOIN---*/
SELECT invoice_number, invoice_date, invoice_total
FROM invoices JOIN vendors
ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = 'CA'
ORDER BY invoice_date;

/*SUBQUERY*/
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN
		(SELECT vendor_id 
		 FROM vendors
		 WHERE vendor_state = 'CA')
ORDER BY invoice_date;


/*--------Advantages of joins

• The SELECT clause of a join can include columns from both tables.

• A join tends to be more intuitive when it uses an existing relationship between the
two tables, such as a primary key to foreign key relationship.*/

/*---------Advantages of subqueries

• You can use a subquery to pass an aggregate value to the main query.

• A subquery tends to be more intuitive when it uses an ad hoc relationship between the two tables.

• Long, complex queries can sometimes be easier to code using subqueries.*/

/*USING WHERE for a Subquery*/

/*WHERE test_expression [NOT] IN (subquery)*/

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id NOT IN
		(SELECT DISTINCT vendor_id
			FROM invoices )
ORDER BY vendor_id;

/*where with comparison operartors (SOME, ANY, ALL)

/*EX: Get invoices with a balance due less than the average*/

SELECT invoice_number, invoice_date,invoice_total - payment_total-credit_total AS balance_due
FROM invoices
WHERE invoice_total-payment_total-credit_total > 0
AND invoice_total - payment_total - credit_total <
		(SELECT AVG(invoice_total - payment_total - credit_total)
		FROM invoices
		WHERE invoice_total - payment_total - credit_total > 0
		) /*without the comparison operators the subquery returns only one value*/
ORDER BY invoice_total DESC;

/*Use the ALL operator*/

SELECT vendor_name, invoice_number, invoice_total
FROM invoices i JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE invoice_total > ALL
		(SELECT invoice_total
        FROM invoices
        WHERE vendor_id = 34) /*en este caso, el query resultante tiene que ser mayor a los dos valores del subquery*/
ORDER BY vendor_name;

/* ANY or SOME keyboards*/

SELECT vendor_name, invoice_number, invoice_total
FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total < ANY /*If we used all then we wouldnt have any results since it will have to be greater than all four values of the subquery*/
		(SELECT invoice_total
        FROM invoices
        WHERE vendor_id = 115);

/*correlated subqueries*/
SELECT vendor_id, invoice_number, invoice_total
FROM invoices i
WHERE invoice_total >
		(SELECT AVG(invoice_total)
		FROM invoices
		WHERE vendor_id = i.vendor_id)
ORDER BY vendor_id, invoice_total;

/* EXISTS operator*/

/*SYNTAX	WERE [NOT] EXISTS (subquery)*/

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE EXISTS
		(SELECT *
        FROM invoices
        WHERE vendor_id = vendors.vendor_id);
        
/*Code a SUBQUERY with a FROM clause*/

SELECT vendor_state, MAX(sum_of_invoices) AS max_sum_of_invoices
FROM
(
	SELECT vendor_state, vendor_name, 
		SUM(invoice_total) AS sum_of_invoices
	FROM vendors v JOIN invoices i
		ON v.vendor_id = i.vendor_id
	GROUP BY vendor_state, vendor_name
    ) t /*When you code a subquery in the FROM clause, you must assign an alias to it.*/
GROUP BY vendor_state
ORDER BY vendor_state;


/*COMPLEX query that uses THREE subqueries*/
	
/*This query retrieves the vendor from each state that has the largest invoice total. To do that, it uses three subqueries*/

SELECT t1.vendor_state, vendor_name, t1.sum_of_invoices
FROM(
-- invoice totals by vendor
	SELECT vendor_state, vendor_name,
		SUM(invoice_total) AS sum_of_invoices
	FROM vendors v JOIN invoices i
		ON v.vendor_id = i.vendor_id
	GROUP BY vendor_state, vendor_name
    ) t1
	JOIN
		(
			-- top invoice totals by state
		SELECT vendor_state,
		MAX(sum_of_invoices) AS sum_of_invoices
		FROM
		(
-- invoice totals by vendor
		SELECT vendor_state, vendor_name,
			SUM(invoice_total) AS sum_of_invoices
		FROM vendors v JOIN invoices i
			ON v.vendor_id= i.vendor_id
		GROUP BY vendor_state, vendor_name
			) t2
			GROUP BY vendor_state
		) t3
	ON tl.vendor_state = t3.vendor_state AND
		tl.sum_of_invoices= t3.sum_of_invoices
ORDER BY vendor_state





