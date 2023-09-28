use [salesdb]

SELECT TOP 10 * FROM Customers

-- ADD COLUMN NAME
SELECT TOP 10 *, (FirstName +' '+ MiddleInitial + ' ' + LastName) AS FullName
FROM Customers 

--ALIAS
SELECT TOP 10 * FROM Products AS P Inner Join Sales AS S ON P.ProductID = S.SalesID

--SUB QUeries
SELECT EmployeeID, FirstName, LastName, Sales.Quantity, SalesPersonID, CustomerID, ProductID, Quantity
FROM Employees inner join Sales on Employees.EmployeeID = Sales.SalesID

SELECT TOP 15 * FROM Customers

SELECT LASTNAME FROM Customers
WHERE LASTNAME LIKE 'B%'

SELECT COUNT (*) FROM Customers
WHERE LASTNAME LIKE 'B%'











