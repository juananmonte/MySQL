SELECT DISTINCT vendor_id, vendor_name
FROM vendors
WHERE vendor_id IN (
		SELECT vendor_id
        FROM invoices)
ORDER BY vendor_name;

SELECT invoice_number, payment_total as total
FROM invoices
WHERE payment_total > (SELECT AVG(payment_total) as average 
							FROM invoices)
ORDER BY payment_total DESC;

SELECT account_number, account_description
FROM general_ledger_accounts
WHERE NOT EXISTS (SELECT *
				  FROM invoice_line_items ilt
                  WHERE account_description = ilt.line_item_description)
ORDER BY account_number;

SELECT vendor_name, invoice_sequence, line_item_amount
FROM invoices inv 
	JOIN invoice_line_items ilt 
    ON inv.invoice_id = ilt.invoice_id
    JOIN vendors ven
    ON inv.vendor_id = ven.vendor_id
WHERE invoice_sequence > 1;

SELECT vendor_id, MAX(invoice_total) AS max_invo_total
FROM(SELECT vendor_id, SUM(invoice_total) AS sum_invoices
	  FROM invoices
      GROUP BY vendor_id) AS t

