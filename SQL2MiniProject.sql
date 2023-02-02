create database SQL2MiniProject;
use SQL2MiniProject;

LOAD DATA INFILE 'D:/Abhinav/Learning/Great Learning/DBMS/DBMS 2/mini project/SQL 2 - Mini - Question/ICC Test Batting Figures.csv'
INTO TABLE ICC_Test_Batting_Figures
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

#    1.	Import the csv file to a table in the database.

SELECT 
* FROM `icc test batting figures`;


#    2.	Remove the column 'Player Profile' from the table.

ALTER TABLE `icc test batting figures` DROP `Player Profile`;


SELECT * 
FROM `icc test batting figures`;
 

#    3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.


alter table `icc test batting figures` 
add Player_name varchar(50) after Player, 
add team varchar(20) after Player_name ;

/*
ALTER TABLE `icc test batting figures`
 DROP team , 
 DROP Player_name;
 */
 
 
 update `icc test batting figures` 
 set player_name =  replace(substring_index(player, '(', 1),' ','')
 ,team =   replace(substring_index(player, '(', -1),')','');

/*
 select replace(substring_index(player, '(', 1),' ','') as player_name
 from `icc test batting figures`;
  select replace(substring_index(player, '(', -1),')','') as team
 from `icc test batting figures`;
 */
 

-- substring_index(substring_index(player, '(', 1), ')', -1)          
		
SELECT SUBSTRING_INDEX("www.w3schools.com", ".", -1);

select substring_index(player, '(', 1)
from `icc test batting figures`;


#    4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.

alter table `icc test batting figures` 
add start_year varchar(4) after span,
add end_year varchar(4) after start_year;

/*
alter table `icc test batting figures` 
drop start_year,
drop end_year;
*/


update `icc test batting figures` 
set start_year = left(span,4),
end_year = right(span,4);

#    5.	The column 'HS' has the highest score scored by the player so far in any given match. The column also has details if the player had completed the match in a NOT OUT status. Extract the data and store the highest runs and the NOT OUT status in different columns.

alter table `icc test batting figures`
add Highest_run text after HS,
add Not_out_status text after Highest_run;

update `icc test batting figures`
set Highest_run = left(HS,3),
Not_out_status = if (right(HS,1)='*','Not Out','Out');


select HS,if (right(HS,1)='*','Not Out','Out')
from `icc test batting figures` ;



SELECT * 
FROM `icc test batting figures`;
 

#    6.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using 
# the selection criteria of those who have a good average score across all matches for India.


SELECT Player,span,Mat,Inn,NO,Runs,itbf.Avg,`100`,`50`,`0`,HS,
dense_rank() over(ORDER BY Avg DESC) Good_Avg_R 
FROM
`icc test batting figures` 
WHERE team = 'India'
AND end_year = 2019
LIMIT 6;

-- OR

SELECT Player,Span,Inn,NO,Avg,`100`,`50`,`0`,HS,
dense_rank() over(ORDER BY Avg DESC) Good_Avg_R
FROM `icc test batting figures` 
WHERE team = 'India'
AND end_year = 2019
LIMIT 6;

#    7.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players 
# using the selection criteria of those who have highest number of 100s across all matches for India.

SELECT Player,Span,Mat,Inn,NO,Runs,Avg,`100`,`50`,`0`,HS,
row_number() over(ORDER by `100` DESC)
FROM `icc test batting figures`
WHERE team = 'India'
AND end_year =  2019
LIMIT 6;

-- OR

SELECT Player,Span,Inn,NO,Avg,`100`,`50`,`0`,HS,
dense_rank() over(ORDER BY `100` DESC)
FROM `icc test batting figures`
WHERE team = 'India'
AND end_year = 2019
LIMIT 6;



#    8.	Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using 2 selection criterias of your own for India.

SELECT Player,Span,Mat,Inn,Runs,HS,Avg,`100`,`50`,
dense_rank() over(ORDER BY `100` DESC , `50` DESC) AS Rank_by_100
FROM `icc test batting figures`
WHERE team = 'India'
AND end_year = 2019
LIMIT 6;

SELECT Player,Span,Mat,Inn,Runs,HS,Avg,`100`,`50`,
dense_rank() over(ORDER BY mat DESC) AS Rank_by_Mat
FROM `icc test batting figures`
WHERE team = 'India'
AND end_year = 2019
LIMIT 6;

#    9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using the selection criteria of those who have a good average score across 
# all matches for South Africa.

CREATE OR REPLACE VIEW Batting_Order_GoodAvgScorers_SA AS 
SELECT Player,team,span,Mat,Inn,Runs,HS,Avg,`100`,`50`,`0`,
row_number() over(ORDER BY Avg DESC) AS Best_average
FROM  `icc test batting figures`
WHERE end_year = 2019
AND Team = 'SA'
LIMIT 6;


SELECT * 
FROM Batting_Order_GoodAvgScorers_SA;



#    10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active
#  in the year of 2019, create a set of batting order of best 6 players using the selection criteria of 
# those who have highest number of 100s across all matches for South Africa.

CREATE  OR REPLACE VIEW Batting_Order_HighestCenturyScorers_SA AS
SELECT player,span,Mat,INN,HS,Runs,Avg,`100`,`50`,
row_number() over(ORDER BY `100` DESC ) as Most_Century
FROM  `icc test batting figures`
WHERE Team  ='SA'
AND end_year = 2019
LIMIT 6;

SELECT *
FROM Batting_Order_HighestCenturyScorers_SA;