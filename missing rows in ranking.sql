DECLARE  @MaxDate DATE, 
         @MinDate DATE, 
         @iDate  DATE
		 
-- SQL Server table variable 

DECLARE  @DateSequence TABLE( 
                          DATE DATE 
                          )

SELECT @MaxDate = Convert(DATE,max(rank_date)), @MinDate = Convert(DATE,min(rank_date))  
FROM   federer_ranking

SET @iDate = @MinDate 

WHILE (@iDate <= @MaxDate) 
  BEGIN 
    INSERT @DateSequence
    SELECT @iDate 
     
    SET @iDate = Convert(DATE,Dateadd(DAY,7,@iDate)) 
  END

SELECT * INTO federer_ranking_updated_dates FROM (select * from @DateSequence) t
 
SELECT * INTO federer_ranking_gaps FROM (
SELECT Gaps = DATE 
FROM   @DateSequence
EXCEPT 
SELECT DISTINCT Convert(DATE,rank_date) 
FROM  federer_ranking
) a

-- FILLING DOWN METHOD --

-- we take the value from the previous row and replace the NULL with it. 
-- There are many features in Python (including the pandas.DataFrame.ffill() function) that accomplish this, 
-- but they are almost always slower than performing the operation directly on the database server.

-- Using the same table above as our sample data, we can replace the null values utilizing both nested queries and window functions.

-- The first thing we want to do is to group the rows with null values with the first non-null value above it. We can do that by utilizing a window function to count the inventory column over the date:

select *, count(rank) over (order by DATE) as _grp
from (
	select * 
	from federer_ranking_updated_dates a
	left outer join federer_ranking b
	on (a.DATE = b.rank_date)
) a;

-- Okay! That gives us a new column that allows us to group together the null values with the first non-null value preceding them. 
-- Now the next step is to return that first value for every row that shares a grouping. Luckily, the first_value window function allows us to do just that.
-- first_value function simply returns the first value for the partition according to the order.

-- We save the result in a new table

with grouped_table as (
   select *, count(rank) over (order by DATE) as _grp
from (
	select * 
	from federer_ranking_updated_dates a
	left outer join federer_ranking b
	on (a.DATE = b.rank_date)
) a)

select DATE as ranking_date,
	   first_value(rank) over (partition by _grp order by DATE) as ranking, 
	   first_value(player) over (partition by _grp order by DATE) as player_id,
	   first_value(points) over (partition by _grp order by DATE) as sum_of_points,
	   first_value(first_name) over (partition by _grp order by DATE) as name,
	   first_value(last_name) over (partition by _grp order by DATE) as surname,
	   first_value(birth_date) over (partition by _grp order by DATE) as day_of_birth,
	   first_value(country) over (partition by _grp order by DATE) as nation
into federer_ranking_complete
from grouped_table

select * from federer_ranking_complete



--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- Same approach for Nadal, we could reuse the gaps and updated dates tables from federer, but he started to compete years before Rafa, 
-- this would lead to have NULL rows at the beginning of the tabel, so as the process is quite fast, we will repeat the same for NAdal and later for Djokovic

DECLARE  @MaxDate DATE, 
         @MinDate DATE, 
         @iDate  DATE
		 
-- SQL Server table variable 

DECLARE  @DateSequence TABLE( 
                          DATE DATE 
                          )

SELECT @MaxDate = Convert(DATE,max(rank_date)), @MinDate = Convert(DATE,min(rank_date))  
FROM   nadal_ranking

SET @iDate = @MinDate 

WHILE (@iDate <= @MaxDate) 
  BEGIN 
    INSERT @DateSequence
    SELECT @iDate 
     
    SET @iDate = Convert(DATE,Dateadd(DAY,7,@iDate)) 
  END

SELECT * INTO nadal_ranking_updated_dates FROM (select * from @DateSequence) t
 
SELECT * INTO nadal_ranking_gaps FROM (
SELECT Gaps = DATE 
FROM   @DateSequence
EXCEPT 
SELECT DISTINCT Convert(DATE,rank_date) 
FROM  nadal_ranking
) a

-- FILLING DOWN METHOD --

with grouped_table as (
   select *, count(rank) over (order by DATE) as _grp
from (
	select * 
	from nadal_ranking_updated_dates a
	left outer join nadal_ranking b
	on (a.DATE = b.rank_date)
) a)

select DATE as ranking_date,
	   first_value(rank) over (partition by _grp order by DATE) as ranking, 
	   first_value(player) over (partition by _grp order by DATE) as player_id,
	   first_value(points) over (partition by _grp order by DATE) as sum_of_points,
	   first_value(first_name) over (partition by _grp order by DATE) as name,
	   first_value(last_name) over (partition by _grp order by DATE) as surname,
	   first_value(birth_date) over (partition by _grp order by DATE) as day_of_birth,
	   first_value(country) over (partition by _grp order by DATE) as nation
into nadal_ranking_complete
from grouped_table

select * from nadal_ranking_complete




--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- Finally, same for Djokovic

DECLARE  @MaxDate DATE, 
         @MinDate DATE, 
         @iDate  DATE
		 
-- SQL Server table variable 

DECLARE  @DateSequence TABLE( 
                          DATE DATE 
                          )

SELECT @MaxDate = Convert(DATE,max(rank_date)), @MinDate = Convert(DATE,min(rank_date))  
FROM   djokovic_ranking

SET @iDate = @MinDate 

WHILE (@iDate <= @MaxDate) 
  BEGIN 
    INSERT @DateSequence
    SELECT @iDate 
     
    SET @iDate = Convert(DATE,Dateadd(DAY,7,@iDate)) 
  END

SELECT * INTO djokovic_ranking_updated_dates FROM (select * from @DateSequence) t
 
SELECT * INTO djokovic_ranking_gaps FROM (
SELECT Gaps = DATE 
FROM   @DateSequence
EXCEPT 
SELECT DISTINCT Convert(DATE,rank_date) 
FROM  djokovic_ranking
) a;

-- FILLING DOWN METHOD --

with grouped_table as (
   select *, count(rank) over (order by DATE) as _grp
from (
	select * 
	from djokovic_ranking_updated_dates a
	left outer join djokovic_ranking b
	on (a.DATE = b.rank_date)
) a)

select DATE as ranking_date,
	   first_value(rank) over (partition by _grp order by DATE) as ranking, 
	   first_value(player) over (partition by _grp order by DATE) as player_id,
	   first_value(points) over (partition by _grp order by DATE) as sum_of_points,
	   first_value(first_name) over (partition by _grp order by DATE) as name,
	   first_value(last_name) over (partition by _grp order by DATE) as surname,
	   first_value(birth_date) over (partition by _grp order by DATE) as day_of_birth,
	   first_value(country) over (partition by _grp order by DATE) as nation
into djokovic_ranking_complete
from grouped_table

select * from djokovic_ranking_complete