
select * from fake_news 

--- identifying data type 


select column_name , data_type 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'fake_news'



---handling null values in author column and source column
UPDATE fake_news
SET author = 'Unknown',
source = 'unknown'
WHERE author IS NULL or source is null ;



---which category has most fake news
select top 1 category , COUNT(category) as no_of_fake_news
from fake_news
where label = 'fake'
group by category 
order by COUNT(category) desc

---top 5  news channel with most fake news 
select source , COUNT(*) 
from fake_news 
where label = 'fake' 
group by source 
order by COUNT(*) desc


---top5 news channel with most real news 
select top 5  source , COUNT(*) as no
from fake_news 
where label = 'real'
group by source
order by COUNT(*) desc


---number of fake news over the year  

with cte as (select  * , case when label = 'fake' then 1 else 0 end as red_flag
from fake_news)
select DATEPART(YEAR,DATE) , SUM(red_flag) as no_of_fake_news
from cte 
group by  DATEPART(YEAR,DATE)
order by SUM(red_flag) desc


---is there any author who have record of spreading more fake news 

select author , COUNT(*) 
from fake_news 
where label = 'fake' 
group by author
having COUNT(*) > 1
order by count(*) desc


---is there any year in which number of fake news is more than  number of real news 

with cte as(select *, case when label = 'fake' then 1 else 0 end as cf , case when label = 'real' then 1 else 0 end as cr
from fake_news)

, cte2 as(select DATEPART(year,date) as yy , SUM(cf) as no_of_fake_news , SUM(cr) as no_of_real_news
from cte 
group by datepart(year,date))

select * 
from cte2 
where no_of_fake_news > no_of_real_news




