--1. Create Dim_Content table
CREATE TABLE Dim_Content(
	ContentID SERIAL PRIMARY KEY,
	Title VARCHAR(255),
	Category VARCHAR(255)
);

--2. Create Fact_Web table
CREATE TABLE Fact_Web(
	RecordID SERIAL PRIMARY KEY,
	ContentID INT,
	SessionID INT,
	EventDate DATE,
	EventType VARCHAR(255),
	FOREIGN KEY (ContentID) REFERENCES Dim_Content(ContentID)
);

--3. Add Data Dim_Content
INSERT INTO Dim_Content(Title, Category)
VALUES
	('Joints','Health'),
	('Money Tips','Finance'),
	('Shopping for Christmas','Commerce'),
	('Recipes', 'Food'),
	('Cardiovascular','Health'),
	('Money Problems','Finance'),
	('Shopping for Holidays','Commerce'),
	('Receipes for Christmas', 'Food'),
	('Heart Disease','Health'),
	('Money','Finance'),
	('Shopping tips','Commerce'),
	('Healthy Recipes', 'Food'),
	('A Healthy Christmas','Health'),
	('Money Times','Finance'),
	('Shopping FAQ','Commerce'),
	('Shopping For The New Year', 'Commerce');

--4. Add data to Fact_Web for the months of September and October. (Write multiple sessionID's for each contentID)
INSERT INTO Fact_Web(ContentID, SessionID, EventDate, EventType)
VALUES
	(1, 01, '09-01-2021','Pageview'),
	(1, 02, '09-02-2021','Action'),
	(1, 03, '09-03-2021','Pageview'),
	(2, 01, '10-01-2021', 'Pageview'),
	(2, 02, '10-02-2021', 'Pageview'),
	(2, 03, '10-03-2021', 'Action'),
	(2, 04, '10-03-2021', 'Action'),
	(2, 05, '10-04-2021', 'Pageview'),
	(3, 01, '09-03-2021','Pageview'),
	(3, 02, '09-04-2021','Action'),
	(3, 03, '10-04-2021','Pageview'),
	(3, 04, '10-05-2021','Action'),
	(3, 05, '09-30-2021','Pageview'),
	(3, 06, '09-30-2021','Action'),
	(3, 07, '10-08-2021','Pageview'),
	(3, 08, '10-09-2021','Pageview'),
	(3, 09, '10-10-2021','Pageview'),
	(4, 01, '09-28-2021', 'Pageview'),
	(4, 02, '09-29-2021', 'Action'),
	(4, 03, '10-03-2021', 'Pageview'),
	(4, 04, '10-04-2021', 'Action'),
	(5, 01, '09-05-2021','Pageview'),
	(5, 02, '09-05-2021','Pageview'),
	(5, 03, '09-07-2021','Pageview'),
	(6, 01, '09-25-2021', 'Action'),
	(6, 02, '09-26-2021', 'Action'),
	(6, 03, '09-27-2021', 'Pageview'),
	(6, 04, '10-08-2021', 'Action'),
	(6, 05, '10-09-2021', 'Pageview'),
	(6, 06, '10-10-2021', 'Action'),
	(7, 01, '10-11-2021','Pageview'),
	(7, 02, '10-12-2021','Action'),
	(7, 03, '10-12-2021','Pageview'),
	(8, 01, '10-13-2021', 'Action'),
	(9, 01, '10-14-2021','Pageview'),
	(9, 02, '10-14-2021','Pageview'),
	(9, 03, '09-25-2021','Action'),
	(9, 04, '10-15-2021','Pageview'),
	(9, 05, '10-15-2021','Pageview'),
	(9, 06, '10-15-2021','Pageview'),
	(10, 01, '09-25-2021', 'Action'),
	(10, 02, '10-16-2021', 'Action'),
	(11, 01, '10-16-2021','Pageview'),
	(11, 02, '10-16-2021','Pageview'),
	(12, 01, '09-25-2021', 'Pageview'),
	(12, 02, '09-26-2021', 'Action'),
	(12, 03, '09-26-2021', 'Action'),
	(12, 04, '09-27-2021', 'Pageview'),
	(12, 05, '10-17-2021', 'Action'),
	(12, 06, '10-18-2021', 'Action'),
	(12, 07, '10-19-2021', 'Pageview'),
	(12, 08, '10-19-2021', 'Action'),
	(12, 09, '10-19-2021', 'Action'),
	(12, 10, '10-20-2021', 'Action'),
	(12, 11, '10-20-2021', 'Pageview'),
	(12, 12, '10-20-2021', 'Action'),
	(13, 01, '09-27-2021', 'Action'),
	(14, 01, '09-27-2021','Action'),
	(14, 02, '09-27-2021','Pageview'),
	(14, 03, '10-21-2021','Action'),
	(14, 04, '10-22-2021','Action'),
	(14, 05, '10-22-2021','Pageview'),
	(15, 01, '10-23-2021', 'Action'),
	(15, 02, '10-23-2021', 'Pageview'),
	(15, 03, '10-24-2021', 'Action'),
	(15, 04, '10-24-2021', 'Action');
	
SELECT * FROM FACT_WEB

--5. Return a list of the top 10 performing content titles based on pageviews in the past month
SELECT DC.Title, COUNT(FW.ContentID) AS Total_Pageviews
FROM Dim_Content DC
JOIN Fact_Web FW
ON DC.ContentID = FW.ContentID
WHERE FW.EventType = 'Pageview'
AND EventDate >= '10-01-2021'
AND EventDate <= '10-31-2021'
-- AND FW.EventDate >= date_trunc('month', current_date)
GROUP BY DC.Title
ORDER BY Total_Pageviews DESC LIMIT 10;

--6. Amend the above query to return another column showing the clicks each of these pieces of content received in the past month
SELECT DC.Title, COUNT(CASE WHEN FW.EventType = 'Pageview' THEN 1 END) AS Total_Pageviews, COUNT(CASE WHEN FW.EventType = 'Action' THEN 1 END) AS Total_Clicks
FROM Dim_Content DC
JOIN Fact_Web FW
ON DC.ContentID = FW.ContentID
WHERE (FW.EventType = 'Pageview'
	   OR FW.EventType = 'Action')
AND FW.EventDate >= date_trunc('month', current_date)
GROUP BY DC.Title
ORDER BY Total_Pageviews DESC LIMIT 10

--7. Return a list of the top 10 performing content titles based on visits
SELECT DC.Title, COUNT(FW.SessionID) AS Total_Visits
FROM Dim_Content DC
JOIN Fact_Web FW
ON DC.ContentID = FW.ContentID
GROUP BY DC.Title
ORDER BY Total_Visits DESC LIMIT 10;

--8. Return a list of content titles that received 0 pageviews in the past month
SELECT DC.ContentID, DC.Title
FROM Dim_Content DC
LEFT JOIN Fact_Web FW
ON DC.ContentID = FW.ContentID
WHERE DC.ContentID NOT IN (
 	SELECT DC.ContentID
 	FROM Dim_Content DC
 	JOIN Fact_Web FW
 	ON DC.ContentID = FW.ContentID
 	WHERE FW.EventType = 'Pageview'
 	AND FW.EventDate >= date_trunc('month', CURRENT_DATE)
 	GROUP BY DC.ContentID
 	)
GROUP BY DC.Title, DC.ContentID
ORDER BY DC.ContentID

--9. Return the count of how many pieces of content had 0 pageviews in the past month grouped by content category
SELECT DC.Category, COUNT(DISTINCT(DC.ContentID)) AS category_count
FROM Dim_Content DC
LEFT JOIN Fact_Web FW
ON DC.ContentID = FW.ContentID
WHERE DC.ContentID NOT IN (
  	SELECT DC.ContentID
  	FROM Dim_Content DC
  	JOIN Fact_Web FW
  	ON DC.ContentID = FW.ContentID
  	WHERE FW.EventType = 'Pageview'
  	AND FW.EventDate >= date_trunc('month', current_date)
  	GROUP BY DC.ContentID)
GROUP BY DC.Category

--10. Return a list of content titles that contain the word ‘christmas’
SELECT DC.Title AS Christmas_Title
FROM Dim_Content DC
WHERE DC.Title LIKE '%Christmas%'
