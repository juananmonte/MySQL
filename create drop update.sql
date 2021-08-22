/*CREATE (COPY) a table*/
CREATE TABLE invoices_copy AS
SELECT *
FROM invoices;

/* INSERT */
INSERT INTO invoices VALUES
( 115, 97 , '456789', '2018-08-01' , 8344.50, 0 , 0, 1, '2018-08-31', NULL);

/* or in this way*/
/*INSERT INTO invoices 
	(vendor_ id, invoice_number, invoice_ total, terms_ id, invoice_date, invoice_due_date)
VALUES
( 97, '456789', 8344.50, 1, '2018-08-01', '2018-08-31')*/

/*INSERT with DEFAULT and NULL*/
INSERT INTO color_sample (color_number)
VALUES (606);

INSERT INTO color_sample (color_name)
VALUES ('YELLOW');

INSERT INTO color_sample
VALUES (DEFAULT, DEFAULT, 'ORANGE'); /*default id and default color number*/

INSERT INTO color_sample
VALUES (DEFAULT, 808, NULL);

INSERT INTO color_sample
VALUES (DEFAULT, DEFAULT, NULL);

/*SUBQUERY*/

/*Without a column list*/
INSERT INTO invoice_archive
SELECT*
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0 ;

/*with a column list*/
INSERT INTO invoice_archive
(invoice_id, vendor_id, invoice_number, invoice_total, credit_total, payment_total, terms_id, invoice_date, invoice_due_date)
SELECT
	invoice_ id, vendor_ id, invoice_number, invoice_ total, credit_ total,
	payment_total, terms_ id, invoice_date, invoice_due_date /*the SELECT LIST MUST MATCH THE ABOVE LIST*/
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;





