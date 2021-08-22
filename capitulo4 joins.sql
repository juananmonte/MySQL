SELECT invoice_number, line_item_amount, line_item_description FROM invoices 
JOIN invoice_line_items AS line_items
ON invoices.invoice_id = line_items.invoice_id
WHERE account_number = 540
ORDER BY invoice_date;

/*Join two tables statements*/ 
SELECT invoice_number, vendor_name, invoice_due_date,
	invoice_total - payment_total - credit_total AS balance_due
FROM vendors v JOIN invoices i
		ON v.vendor_id = i.vendor_id
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY invoice_due_date DESC;

/*joining two databases*/
SELECT vendor_name, customer_last_name, customer_first_name, vendor_state AS state, vendor_city AS city
FROM vendors v
JOIN ex.customers c
ON v.vendor_zip_code = c.customer_zip
ORDER BY state, city;
/*An inner join with two conditions*/
/*doesnt work, we need the customers database*/
SELECT customer_first_name, customer_ last_name
FROM customer c JOIN ex.employees e
ON c.customer_first_name = e.first_name
AND c.cutomer_last_name = e.last_name;


/*Join more than two tables statements*/ 
SELECT vendor_name, invoice_number, invoice_date,
line_item_amount, account_description
FROM vendors v 
	JOIN invoices i 
		ON v.vendor_id = i.vendor_id
	JOIN invoice_line_items li
		ON i.invoice_id = li.invoice_id
	JOIN general_ledger_accounts gl
		ON li.account_number = gl.account_number
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name, line_item_amount DESC;


/*implicit joining*/
SELECT invoice_number, vendor_name
FROM vendors v, invoices i
WHERE v.vendor_id = i.vendor_id
ORDER BY invoice_number;
/*if we wanted to join more tables, we need to use the AND operator after  WHERE and just qualigy the tables*/


/* How to work with outer joins*/
/*LEFT join*/

SELECT vendor_name, invoice_number, invoice_total
FROM vendors LEFT JOIN invoices
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;

/*Combine an outer and an inner join*/

SELECT department_name, last_name, project_nwnber
FROM departments d
	JOIN employees e
		ON d. department_nwnber = e. department_number
	LEFT JOIN projects p
		ON e.employee_id = p.employee_id
ORDER BY department_name, last_name ;

/* The USING statement*/
SELECT department_name, last_name, project_number
FROM departments
JOIN employees USING (department_ number)
LEFT JOIN projects USING (employee_id)
ORDER BY department_name;

/*the NATURAL statement*/
SELECT department_name AS dept_name, last_name, project_number
FROM departments
NATURAL JOIN employees
LEFT JOIN projects USING (employee_ id)
ORDER BY departme.nt_name
