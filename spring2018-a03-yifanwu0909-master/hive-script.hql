SELECT name,
SUM(occurs), 
SUM(books),
SUM(occurs)/SUM(books)*1.0 AS aopb,
MIN(year) AS minyear,
MAX(year) AS maxyear,
COUNT(year) AS yearnum
FROM table0
GROUP BY name
HAVING maxyear = 2009
AND minyear = 1950
AND yearnum = 60
ORDER BY aopb DESC
LIMIT 10;
