CREATE DATABASE Chinook;

USE Chinook;
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

/*===
  PROJECT : Chinook Music Store Analysis
  AUTHOR  : Handahamé DIA | DATE : May 2026
===*/

-- ====
-- THEME 1: Customer Analysis
-- ===

-- Ex1 : International customers outside the USA
-- ===
-- Context     : The marketing team is preparing an international advertising campaign
-- Objective   : Identify all customers outside the USA
-- Recipient   : Marketing Team
-- ===

SELECT 
CustomerID, 
FirstName + ' ' + LastName AS CompleteName, 
Country, 
City 
FROM Customer  
WHERE Country <> 'USA' 
ORDER BY COUNTRY ASC;

--  ====
-- Ex2 : Brazilian customers and their contacts
-- ====
-- Context     : The sales team is preparing an exclusive promotion for the Brazilian market
-- Objective   : Extract contact details of Brazilian customers
-- Recipient   : Sales Team South America
-- ====

SELECT 
CustomerID, 
FirstName + ' ' + LastName AS CompleteName, 
Email,
Country, 
City
FROM CUSTOMER 
WHERE Country = 'Brazil'
ORDER BY CompleteName ASC

-- Ex3 : Invoices from Brazilian customers
-- ===
-- Context     : The accounting department is preparing a quarterly audit on the Brazilian market
-- Objective   : Cross-reference customer and invoice data to analyze activity in Brazil
-- Recipient   : Accounting & Finance Department
-- ===

SELECT 
c.FirstName + ' ' + c.LastName AS CompleteName, 
i.InvoiceId,
i.InvoiceDate,
i.BillingCountry,
i.BillingCity
FROM customer c
INNER JOIN invoice i
ON c.CustomerId = i.CustomerId
WHERE c.Country = 'Brazil'
ORDER BY CompleteName ASC;

-- ===
-- Ex4 : Sales Support Agents
-- ===
-- Context     : The HR department is preparing a training plan
-- Objective   : Identify employees in direct contact with customers
-- Result      : List of agents with name, title and email
-- ===

SELECT
e.EmployeeId, 
e.FirstName + ' ' + e.LastName AS CompleteName,
e.Title,
e.Email
FROM Employee e
Where e.Title = 'Sales Support Agent'
ORDER BY CompleteName ASC;

-- ===
-- THEME 2 — Sales Analysis
-- ===

-- ===
-- Ex5 : Active markets overview
-- ===
-- Context     : The sales director wants a global view of the markets where Chinook operates
-- Objective   : List all billing countries without duplicates
-- Result      : Unique list of customer countries
-- ===

SELECT DISTINCT BillingCountry AS Country
FROM Invoice
ORDER BY Country ASC;

-- ===
-- Ex6 : Invoices per sales agent
-- ===
-- Context     : The sales director wants to know which invoices are handled by which agent
-- Objective   : Cross-reference invoices with sales agents
-- Recipient   : Sales Management
-- ===

SELECT
e.FirstName + ' ' + e.LastName AS EmployeeName,
i.invoiceId,
i.Total
FROM Customer c
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
INNER JOIN Employee e
ON c.SupportRepId =e.EmployeeId
ORDER BY EmployeeName ASC;

-- ===
-- Ex7 : Full transaction report
-- ===
-- Context     : The Finance department wants to analyze each transaction in detail
-- Objective   : Cross-reference invoices, customers and agents
-- Recipient   : Finance Department
-- ===

SELECT 
e.FirstName + ' ' + e.LastName AS EmployeeName,
c.FirstName + ' ' + c.LastName AS CustomerName,
i.BillingCountry,
i.invoiceId,
i.Total
FROM customer c
INNER JOIN Invoice i
ON c.CustomerId =i.CustomerId
INNER JOIN Employee e
ON c.SupportRepId = e.EmployeeId
ORDER BY EmployeeName ASC;

-- ===
-- Ex8 : Sales analysis by year
-- ===
-- Context     : Management wants to compare commercial activity between 2021 and 2023
-- Objective   : Count invoices and calculate total sales for each year
-- Recipient   : General Management
-- ===

SELECT		
YEAR(InvoiceDate) AS TheYear,
COUNT(InvoiceId) AS NumberInvoices,
SUM(Total) AS TotalSales
FROM Invoice
WHERE YEAR(InvoiceDate) IN (2021, 2023)
Group BY YEAR(InvoiceDate)
ORDER BY TotalSales DESC;

-- ===
-- Ex9 : Line items for a specific invoice
-- ===
-- Context     : The Finance department wants to verify the details of a specific invoice
-- Objective   : Count the number of line items for invoice n°37
-- Recipient   : Finance Department
-- ===

SELECT 
COUNT(InvoiceLineId) AS Total_Items
FROM InvoiceLine 
WHERE InvoiceId = 37;

-- ===
-- Ex10 : Number of line items per invoice
-- ===
-- Context     : The Finance department wants to analyze the composition of all invoices
-- Objective   : Count the number of line items for each invoice
-- Recipient   : Finance Department
-- ===

SELECT InvoiceId,
COUNT(InvoiceLineId) AS Total_Items
FROM InvoiceLine 
GROUP BY InvoiceId
ORDER BY Total_Items DESC;

-- ===
-- THEME 3 — Tracks & Artists Analysis
-- ===

-- ===
-- Ex11 : Track details per invoice
-- ===
-- Context     : The product team wants to analyze which tracks are purchased together
-- Objective   : Display the track name for each invoice line
-- Recipient   : Product Team
-- ===

SELECT 
il.InvoiceLineId,
il.InvoiceId,
t.Name AS TrackName
FROM Invoiceline il
INNER JOIN Track t
ON il.TrackId = t.TrackId
ORDER BY il.InvoiceId ASC;

-- ===
-- Ex12 : Tracks and artists per invoice
-- ===
-- Context     : The marketing team wants to identify the most purchased artists
-- Objective   : Display the track name AND the artist name for each invoice line
-- Recipient   : Marketing Team
-- ===

SELECT 
il.InvoiceId,
t.Name AS TrackName,
a.Name AS ArtistName
FROM InvoiceLine il
INNER JOIN Track AS t
ON il.TrackId = t.TrackId
INNER JOIN Album al
ON t.AlbumId = al.AlbumId
INNER JOIN Artist a 
ON al.ArtistId = a.ArtistId
ORDER BY ArtistName ASC;

-- ===
-- Ex13 : Invoice distribution by country
-- ===
-- Context     : The sales team wants to identify the most active markets
-- Objective   : Count the number of invoices per country
-- Recipient   : Sales Team
-- ===

SELECT 
BillingCountry,
COUNT(InvoiceId) AS NumberInvoice
FROM Invoice
GROUP BY BillingCountry
ORDER BY NumberInvoice DESC;

-- ===
-- Ex14 : Playlist popularity
-- ===
-- Context     : The product team wants to know which playlists have the most tracks
-- Objective   : Count the number of tracks in each playlist
-- Recipient   : Product Team
-- ===

SELECT
p.Name AS Playlist_Name,
Count(t.TrackId) AS Numbers_Tracks
FROM Track t
INNER JOIN PlaylistTrack pk
ON t.TrackId = pk.TrackId
INNER JOIN Playlist p
ON pk.PlaylistId = p.PlaylistId
GROUP BY P.Name
ORDER BY Numbers_Tracks DESC;

-- ===
-- Ex15 : Full track catalog
-- ===
-- Context     : The product team wants a complete view of the music catalog
-- Objective   : List all tracks with their album, media type and genre
--               without displaying technical IDs
-- Recipient   : Product Team
-- ===

SELECT 
	t.Name AS TrackName,
	a.Title AS AlbumName,
	m.Name AS MediaType_Name,
	g.Name AS GenreName
	FROM Track t
INNER JOIN Album a
	ON t.AlbumId = a.AlbumId
INNER JOIN MediaType m
	ON t.MediaTypeId = m.MediaTypeId
INNER JOIN Genre g
	ON t.GenreId = g.GenreId
Order BY AlbumName ASC;

-- ====
-- THEME 4 — Reporting & Aggregations
-- ===

-- ===
-- Ex16 : Global invoice overview
-- ===
-- Context     : The Finance department wants a complete report on all transactions
-- Objective   : Display all invoices with the number of line items per invoice
-- Recipient   : Finance Department
-- ===

SELECT 
i.InvoiceId,
COUNT(il.InvoiceLineId) AS Items_Per_Invoice
FROM Invoice i
INNER JOIN InvoiceLine il
ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId
ORDER BY Items_Per_Invoice DESC;

-- ===
-- Ex17 : Total sales per sales agent
-- ===
-- Context     : Management wants to evaluate the performance of each agent
-- Objective   : Calculate the total sales made by each agent
-- Recipient   : General Management
-- ===

SELECT 
e.EmployeeId,
e.FirstName + ' ' + e.LastName AS EmployeeName,
SUM(i.Total) AS Total_Sales
FROM Invoice i
INNER JOIN Customer c
ON i.CustomerId = c.CustomerId
INNER JOIN Employee e
ON c.SupportRepId = e.EmployeeID
GROUP BY e.EmployeeId, e.FirstName + ' ' + e.LastName 
ORDER BY Total_Sales DESC

-- ===
-- Ex18 : Best sales agent in 2021
-- ===
-- Context     : Management wants to reward the best agent of 2021
-- Objective   : Identify the agent with the highest sales in 2021
-- Recipient   : General Management
-- ===

SELECT TOP 1
e.FirstName + ' ' + e.LastName AS EmployeeName,
SUM(i.Total) AS Total_Sales
FROM Invoice i
INNER JOIN Customer c
ON i.CustomerId = c.CustomerId
INNER JOIN Employee e
ON c.SupportRepId = e.EmployeeID
WHERE YEAR(i.InvoiceDate) = 2021
GROUP BY e.FirstName + ' ' + e.LastName 
ORDER BY Total_Sales DESC;

-- ===
-- Ex19 : Best sales agent in 2022
-- ====
-- Context     : Management wants to compare performance between 2021 and 2022
-- Objective   : Identify the agent with the highest sales in 2022
-- Recipient   : General Management
-- ===

SELECT TOP 1
e.FirstName + ' ' + e.LastName AS EmployeeName,
SUM(i.Total) AS Total_Sales
FROM Invoice i
INNER JOIN Customer c
ON i.CustomerId = c.CustomerId
INNER JOIN Employee e
ON c.SupportRepId = e.EmployeeId
WHERE YEAR(i.InvoiceDate) = 2022
GROUP BY e.FirstName + ' ' + e.LastName 
ORDER BY Total_Sales DESC;

-- ===
-- Ex20 : Best overall sales agent
-- ===
-- Context     : Management wants to identify the best agent across all years
-- Objective   : Identify the agent with the highest total sales
-- Recipient   : General Management
-- ===

SELECT TOP 1 
e.FirstName + ' ' + e.LastName AS EmployeeName,
SUM(i.Total) AS Total_Sales
FROM Invoice i
INNER JOIN Customer c
ON i.CustomerId = c.CustomerId
INNER JOIN Employee e
ON c.SupportRepId = e.EmployeeID
GROUP BY e.FirstName + ' ' + e.LastName 
ORDER BY Total_Sales DESC

-- ===
-- Ex21 : Customers per sales agent
-- ===
-- Context     : The HR department wants to evaluate the workload of each agent
-- Objective   : Count the number of customers assigned to each agent
-- Recipient   : HR Department
-- ===

SELECT 
e.FirstName + ' ' + e.LastName AS EmployeeName,
COUNT(c.CustomerId) AS NumberCustomers
FROM Employee e
INNER JOIN Customer c
ON e.Employeeid = c.SupportRepId
GROUP BY e.FirstName + ' ' + e.LastName
ORDER BY NumberCustomers DESC

-- ===
-- Ex22 : Total sales by country
-- ===
-- Context     : Management wants to identify the most profitable markets
-- Objective   : Calculate total sales by country and identify the top spending country
-- Recipient   : Sales Management
-- ===

SELECT 
BillingCountry,
SUM(Total) AS TotalSales
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalSales DESC

-- ===
-- Ex23 : Most purchased track in 2023
-- ===
-- Context     : The marketing team wants to align campaigns with music trends
-- Objective   : Identify the most purchased track in 2023
-- Recipient   : Marketing Team
-- ===

SELECT TOP 1 
t.Name AS TrackName,
SUM(il.Quantity) AS QuantitySold
FROM InvoiceLine il
INNER JOIN Track t 
ON il.TrackId = t.TrackID
INNER JOIN Invoice i
ON il.InvoiceId = i.InvoiceId 
WHERE YEAR(i.InvoiceDate) = 2023
GROUP BY t.Name
ORDER BY QuantitySold DESC;

-- ===
-- Ex24 : Top 5 most purchased tracks
-- ===
-- Context     : The product team wants to highlight the most popular tracks
-- Objective   : Identify the 5 most purchased tracks across all years
-- Recipient   : Product Team
-- ===

SELECT TOP 5 WITH TIES
t.Name AS TrackName,
SUM(il.Quantity) AS QuantitySold
FROM InvoiceLine il
INNER JOIN Track t 
ON il.TrackId = t.TrackID
GROUP BY t.Name
ORDER BY QuantitySold DESC

-- ===
-- Ex25 : Top 3 best-selling artists
-- ===
-- Context     : The marketing team wants to negotiate partnerships with top artists
-- Objective   : Identify the 3 artists with the highest total sales
-- Recipient   : Marketing Team
-- ===

SELECT TOP 3 WITH TIES
a.Name AS ArtistName,
SUM(il.UnitPrice * il.Quantity) AS TotalSales
FROM InvoiceLine il
INNER JOIN Track t
ON il.TrackId = t.TrackId
INNER JOIN Album al
ON t.AlbumId = al.AlbumId
INNER JOIN Artist a
ON al.ArtistId = a.ArtistId
GROUP BY a.Name
ORDER BY TotalSales DESC

-- ===
-- Ex26 : Most purchased media type
-- ===
-- Context     : The product team wants to align its strategy with the most popular formats
-- Objective   : Identify the most purchased media type
-- Recipient   : Product Team
-- ===

SELECT TOP 1 WITH TIES
m.Name AS MediaType_Name,
COUNT(il.InvoiceLineId) AS NumberPurchases
FROM InvoiceLine il
INNER JOIN Track t 
ON il.TrackId = t.TrackId
INNER JOIN MediaType m 
ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY NumberPurchases DESC 
