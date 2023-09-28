SELECT * FROM Customer
SELECT * FROM payment

SELECT c.customer_id, c.first_name, p.amount   
FROM customer c
RIGHT JOIN payment p
ON c.customer_id = p.customer_id
WHERE amount >= '10.99'

SELECT * FROM LANGUAGE
ALTER TABLE LANGUAGE
ADD COLUMN Language_spoken varchar(255)

UPDATE LANGUAGE
SET language_spoken ='Fante', name = 'German'
WHERE language_id = 6



