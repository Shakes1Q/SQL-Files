select * from [dbo].[sales_data_sample]

--Check unique values
select distinct STATUS from dbo.sales_data_sample
select distinct Country from dbo.sales_data_sample
select distinct year_id from dbo.sales_data_sample
select distinct Productline from dbo.sales_data_sample
select distinct dealsize from dbo.sales_data_sample

select distinct month_id from dbo.sales_data_sample where year_id = 2003

--Analysis
--- Grouping sales by productive
select productline,  sum(SALES) Revenue from dbo.sales_data_sample
group by productline 
order by 2 desc

--Most sales by year
select  year_id, sum(SALES) Revenue from dbo.sales_data_sample
group by year_id 
order by 2 desc

select dealsize, sum(SALES) Revenue from dbo.sales_data_sample
group by dealsize 
order by 2 desc

--what was the best month sales in a specific year? how much was earned that month?
select month_id, sum(SALES) Revenue, count (ORDERNUMBER) Frequency from dbo.sales_data_sample
where year_id = 2004
group by month_id 
order by 2 desc
--Nov had the best month sales with over a million sales--

--What product was sold the most in November?
select month_id, productline, sum(SALES) Revenue, count(ORDERNUMBER) from dbo.sales_data_sample
where year_id =2003 and month_id =11
group by month_id, productline 
order by 3 desc
--Classic cars was sold the most.

-- Who is our best customer (using RFM analysis)
Drop Table if Exists #rfm
;with rfm as (
select CUSTOMERNAME, 
		sum(sales) Monetaryvalue, 
		avg(sales) AvgMonetaryvalue, 
		count(ORDERNUMBER) frequency, 
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from dbo.sales_data_sample) max_order_date,
		DATEDIFF (day, max(ORDERDATE), (select max (ORDERDATE) from [dbo].[sales_data_sample] )) Recency
from [airbnb] . [dbo].[sales_data_sample]
group by CUSTOMERNAME
),
rfm_calc as(
select r. * ,
		NTILE(4) OVER (order by Recency desc) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
from rfm r 
)
select c. *, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary as varchar)rfm_cell_string
into #rfm
from rfm_calc c


select CUSTOMERNAME,  rfm_recency, rfm_frequency, rfm_monetary,
         case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm

--What products are mostly sold together?
--select * from sales where ordernumber = 10411
select productcode from dbo.sales_data_sample where ordernumber in (
select ordernumber from (
select ordernumber , count(*) rn 
from dbo.sales_data_sample
where status = 'Shipped'
group by ordernumber
)m
where rn = 2
)

--What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from [dbo].[sales_data_sample]
where country = 'France'
group by city
order by 2 desc

---What is the best product in France?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
where country = 'France'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc