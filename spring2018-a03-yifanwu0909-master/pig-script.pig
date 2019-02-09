table = LOAD '/user/hadoop/bigrams/googlebooks-eng-us-all-2gram-20120701-i?' AS (name:chararray, year:int, occur:int, book:int);

by_name = GROUP table BY name;

final = FOREACH by_name GENERATE 
group as name,
SUM(table.occur) AS sum_occur, 
SUM(table.book) AS sum_book,
SUM(table.occur)*1.0/SUM(table.book) AS rate,
MIN(table.year) AS min_year,
MAX(table.year) AS max_year,
COUNT(table.year) AS year_count;

filter_final = FILTER final BY (max_year == 2009) AND (min_year == 1950) AND (year_count == 60);

order_final = ORDER filter_final BY rate DESC;

limit_final = LIMIT order_final 10;

STORE limit_final INTO 'pig-results' USING PigStorage(',');
