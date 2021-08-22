SELECT invoice_due_date AS Due_Date, 
		invoice_total AS Invoice_Total, (invoice_total*0.10) AS '10%', 
        (invoice_total + '10%') AS 'Plus_10%'
FROM invoices;

 