-- Created a new tabel to perserve the integrity of the original dataset

CREATE TABLE clean_table_3
LIKE messy_imdb_dataset;

-- Verifying that the new table was created successfully

SELECT *
FROM clean_table_3;

-- Copy all data from the original dataset into the new table

INSERT clean_table_3
SELECT *
FROM messy_imdb_dataset;

-- Confirm that the data was successfully copied

SELECT *
FROM clean_table_3;

-- Identify duplicates by adding a row number partitioned by key attributes

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `IMBD title ID`,
 `Original titlÊ`, `Release year`, `Genrë¨`, `Duration`, `Country`, `Content Rating`, `Director`, `MyUnknownColumn`, `Income`, `Votes`, `Score`)  AS row_num
FROM clean_table_3;

-- Use a CTE to isolate duplicate rows for review


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `IMBD title ID`,
 `Original titlÊ`, `Release year`, `Genrë¨`, `Duration`, `Country`, `Content Rating`, `Director`, `MyUnknownColumn`, `Income`, `Votes`, `Score`)  AS row_num
FROM clean_table_3
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Created a new table that includes the row number column for eaier duplicate handling

CREATE TABLE `clean_table_4` (
  `IMBD title ID` text,
  `Original titlÊ` text,
  `Release year` text,
  `Genrë¨` text,
  `Duration` text,
  `Country` text,
  `Content Rating` text,
  `Director` text,
  `MyUnknownColumn` text,
  `Income` text,
  `Votes` text,
  `Score` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Verify taht the new table was created successfuly

SELECT *
FROM clean_table_4;

-- Populate the new table with data

INSERT INTO clean_table_4
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `IMBD title ID`,
 `Original titlÊ`, `Release year`, `Genrë¨`, `Duration`, `Country`, `Content Rating`, `Director`, `MyUnknownColumn`, `Income`, `Votes`, `Score`)  AS row_num
FROM clean_table_3;

-- Confirm that the data was successfully inserted

SELECT *
FROM clean_table_4;

-- Identify duplicate rows

SELECT *
FROM clean_table_4
WHERE row_num > 1;

-- code for deleting dupplicates

DELETE
FROM clean_table_4
WHERE row_num > 1;

-- Standardize values by trimming spaces and correcting inconsistencies
-- EX: correctinf spelling, encoding issues, and altering naming convenrions

SELECT `IMBD title ID`, TRIM(`IMBD title ID`)
FROM clean_table_4;

UPDATE clean_table_4
SET `IMBD title ID` = TRIM(`IMBD title ID`);

SELECT DISTINCT `Original titlÊ`
FROM clean_table_4;

UPDATE clean_table_4
SET `Original titlÊ` = 'Seven'
WHERE `Original titlÊ` = 'Se7en';

UPDATE clean_table_4
SET `Original titlÊ` = 'Leon'
WHERE `Original titlÊ` =  'LÃ©on';

UPDATE clean_table_4
SET `Original titlÊ` = 'La vita è bella'
WHERE `Original titlÊ` = 'La vita B9 bella';

UPDATE clean_table_4
SET `Original titlÊ` = "Le Fabuleux Destin D'Amelie Poulain"
WHERE `Original titlÊ` = "Le fabuleux destin d'AmÃ©lie Poulain";

UPDATE clean_table_4
SET `Original titlÊ` = 'WALL-E'
WHERE `Original titlÊ` = 'WALLÂ·E';

SELECT *
FROM clean_table_4
WHERE `Country` LIKE 'New %'
ORDER BY 1;

SELECT DISTINCT `Country`, TRIM(TRAILING '.' FROM Country)
FROM clean_table_4
ORDER BY 1;

UPDATE clean_table_4
SET Country = TRIM(TRAILING '1' FROM Country)
WHERE country LIKE 'Italy%';

UPDATE clean_table_4
SET Country = TRIM(Country)
WHERE Country LIKE 'New %';

UPDATE clean_table_4
SET `Country` = 'New Zealand'
WHERE `Country` = "New Zesland" "New Zealand" "New Zeland";

UPDATE clean_table_4
SET `Duration` = '133'
WHERE `Duration` = '-';

UPDATE clean_table_4
SET `Duration` = '124'
WHERE `Duration` = 'Not Applicable';

UPDATE clean_table_4
SET `Duration` = '184'
WHERE `Duration` = 'Nan';

UPDATE clean_table_4
SET `Duration` = '154'
WHERE `Duration` = ' ';

UPDATE clean_table_4
SET `Duration` = '136'
WHERE `Duration` = 'NULL';

UPDATE clean_table_4
SET `Duration` = '100'
WHERE `Duration` = 'Inf';

UPDATE clean_table_4
SET `Duration` = 136
WHERE `Duration` IS NULL;

UPDATE clean_table_4
SET `Duration` = '176'
WHERE `Duration` = '178c';

SELECT DISTINCT `Content Rating`
FROM clean_table_4;

UPDATE clean_table_4
SET  `Content Rating` = CASE
WHEN `Content Rating` IN ('#N/A', 'Unrated', 'Not Rated', 'Approved') THEN 'NR'
ELSE `Content Rating`
END;

SELECT DISTINCT `Votes`
FROM clean_table_4;

SELECT DISTINCT `Score`
FROM clean_table_4;

UPDATE clean_table_4
SET `Score` = '9.0'
WHERE `Score` = '9,.0';

UPDATE clean_table_4
SET `Score` = '8.7'
WHERE `Score` = '8,7e-0';

UPDATE clean_table_4
SET `Score` = '8.6'
WHERE `Score` = '8,6';

UPDATE clean_table_4
SET `Score` = '8.7'
WHERE `Score` = '++8.7';

UPDATE clean_table_4
SET `Score` = '8.8'
WHERE `Score` = '8:8';

UPDATE clean_table_4
SET `Score` = '8.9'
WHERE `Score` = '8,9f';

UPDATE clean_table_4
SET `Score` = '8.9'
WHERE `Score` = '08.9';

UPDATE clean_table_4
SET `Score` = '8.7'
WHERE `Score` = '8.7.';

UPDATE clean_table_4
SET `Score` = '9.0'
WHERE `Score` = '9.';

UPDATE clean_table_4
SET `Score` = '8.8'
WHERE `Score` = '8..8';

SELECT DISTINCT `Income`
FROM clean_table_4;

UPDATE clean_table_4
SET `Income` =  '$ 408035783'
WHERE `Income` = '$ 4o8,035,783';

-- check all data has been fixed

SELECT *
FROM clean_table_4;

-- Fix dates
-- (some of the dates that i fixed i had to look up since the dates provided were invalid)

SELECT `Release year`,
STR_TO_DATE(`Release year`, '%Y-%m-%d')
FROM clean_table_4;

UPDATE clean_table_4
SET `Release year` = '1946-11-21'
WHERE `Release year` = '21-11-46';

UPDATE clean_table_4
SET `Release year` = '1951-03-06'
WHERE `Release year` = 'The 6th of marzo, year 1951';

UPDATE clean_table_4
SET `Release year` = '1966-12-23'
WHERE `Release year` = '23rd December of 1966 ';

UPDATE clean_table_4
SET `Release year` = '1972-09-21'
WHERE `Release year` = '09 21 1972';

UPDATE clean_table_4
SET `Release year` = '1976-11-18'
WHERE `Release year` = '18/11/1976';

UPDATE clean_table_4
SET `Release year` = '1976-11-24'
WHERE `Release year` = '1976-13-24';

UPDATE clean_table_4
SET `Release year` = '1999-10-29'
WHERE `Release year` = '10-29-99';

UPDATE clean_table_4
SET `Release year` = '1999-10-29'
WHERE `Release year` = '10-29-99';

UPDATE clean_table_4
SET `Release year` = '1983-12-09'
WHERE `Release year` = '1984-02-34';

UPDATE clean_table_4
SET `Release year` = '2003-12-17'
WHERE `Release year` = '22 Feb 04';


UPDATE clean_table_4
SET `release_year` = '2008-07-23'
WHERE `release_year` = ' 23 -07-2008';

UPDATE clean_table_4
SET `Release year` = '2002-12-18'
WHERE `Release year` = '01/16-03';

-- Identify and delet completly blank or null rows

SELECT *
FROM clean_table_4
WHERE (`IMBD title ID` IS NULL OR `IMBD title ID` = '')
 AND (`Original titlÊ` IS NULL OR `Original titlÊ` = '')
AND (`Release year` IS NULL OR `Release year` = '')
AND (`Genrë¨` IS NULL OR `Genrë¨` = '')
AND (`Duration` IS NULL OR `Duration` = '')
AND (`Country` IS NULL OR `Country` = '')
AND (`Content Rating` IS NULL OR `Content Rating` = '')
AND (`Director` IS NULL OR `Director` = '')
AND (`MyUnknownColumn` IS NULL OR `MyUnknownColumn` = '')
AND (`Income` IS NULL OR `Income` = '')
AND (`Votes` IS NULL OR `Votes` = '')
AND (`Score` IS NULL OR `Score` = '');

DELETE FROM clean_table_4
WHERE (`IMBD title ID` IS NULL OR `IMBD title ID` = '')
 AND (`Original titlÊ` IS NULL OR `Original titlÊ` = '')
AND (`Release year` IS NULL OR `Release year` = '')
AND (`Genrë¨` IS NULL OR `Genrë¨` = '')
AND (`Duration` IS NULL OR `Duration` = '')
AND (`Country` IS NULL OR `Country` = '')
AND (`Content Rating` IS NULL OR `Content Rating` = '')
AND (`Director` IS NULL OR `Director` = '')
AND (`MyUnknownColumn` IS NULL OR `MyUnknownColumn` = '')
AND (`Income` IS NULL OR `Income` = '')
AND (`Votes` IS NULL OR `Votes` = '')
AND (`Score` IS NULL OR `Score` = '');

-- Rename columns for consistancy and clarity

ALTER TABLE clean_table_4
RENAME COLUMN `Original titlÊ` TO `Original_Title`,
RENAME COLUMN `Genrë¨` TO `Genre`,
RENAME COLUMN `IMBD title ID` TO `IMDB_Title_ID`;

ALTER TABLE clean_table_4
RENAME COLUMN `IMDB_Title_ID` TO imdb_title_id,
RENAME COLUMN `Original_Title` TO original_title,
RENAME COLUMN `Release year` TO release_year,
RENAME COLUMN `Genre` TO genre,
RENAME COLUMN `Duration` TO duration_min,
RENAME COLUMN `Country` TO country,
RENAME COLUMN `Content Rating` TO content_rating,
RENAME COLUMN `Director` TO director,
RENAME COLUMN `Income` TO income_usd,
RENAME COLUMN `Votes` TO votes,
RENAME COLUMN `Score` TO score;

-- Convert release_year to a DATE format for consistency

SELECT DISTINCT release_year
FROM clean_table_4
ORDER BY release_year;

ALTER TABLE clean_table_4
MODIFY COLUMN release_year DATE;

-- Remove unccecessry columns no longer required for analysis

SELECT *
FROM clean_table_4;

ALTER TABLE clean_table_4
DROP COLUMN row_num;

ALTER TABLE clean_table_4
DROP COLUMN MyUnknownColumn;





























