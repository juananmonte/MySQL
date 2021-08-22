SELECT vendor_id, SUM (invoice_total) AS invoice_total
FROM invoices
GROUP BY vendor_id;


SELECT vendor_name, SUM(payment_total) AS payment_total
FROM invoices JOIN vendors
	ON vendors.vendor_id = invoices.vendor_id
GROUP BY vendor_name
ORDER BY payment_total DESC;

SELECT vendor_name, COUNT(*) AS count_invoices, SUM(invoice_total) AS invoice_total
FROM invoices JOIN vendors
	ON invoices.vendor_id = vendors.vendor_id
GROUP BY vendor_name
ORDER BY invoice_total DESC;

SELECT account_description, COUNT(*) AS items_count, SUM(line_item_amount) AS item_total
FROM general_ledger_accounts gla JOIN invoice_line_items ilt
	ON gla.account_number = ilt.account_number
GROUP BY account_description
	HAVING items_count > 1
ORDER BY item_total DESC;

SELECT account_description,  invoice_date, COUNT(*) AS items_count, SUM(line_item_amount) AS item_total
FROM general_ledger_accounts gla 
	JOIN invoice_line_items ilt
	ON gla.account_number = ilt.account_number
    JOIN invoices inv
	ON inv.invoice_id = ilt.invoice_id
GROUP BY account_description
	HAVING invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
ORDER BY item_total DESC