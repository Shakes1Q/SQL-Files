select * from [dbo].['Sales']
select _ProductID * [Order Quantity] AS Cashflow from [dbo].['Sales']
-----
Select MAX(OrderDate) from [dbo].['Sales']

DECLARE @today_date AS DATE = '2021-01-01';
WITH base AS (

SELECT _CustomerID AS customer_id
--,MAX(OrderDate) as Most_recently_purchase_date
,DATEDIFF(day, MAX(OrderDate), @today_date) as recency_score  
,COUNT(OrderNumber) as frequency_score
,CAST(SUM([Unit Price] - ([Unit Price] * [Discount Applied]) - [Unit Cost]) as DECIMAL(16, 0)) as monetary_score
FROM [dbo].['Sales']
GROUP BY _CustomerID
),

rfm_scores AS (
SELECT customer_id
				,recency_score
				,frequency_score
				,monetary_score
				,NTILE(5) OVER (ORDER BY recency_score DESC) as R 
				,NTILE(5) OVER (ORDER BY frequency_score ASC) as F
				,NTILE(5) OVER (ORDER BY monetary_score ASC) as M 
FROM base
)

Select (R + F + M) / 3  as rfm_group 
,COUNT(rfm.customer_id) as customer_count
,SUM(base.monetary_score) as total_revenue
,CAST(SUM(base.monetary_score) / COUNT (rfm.customer_id) as decimal (12, 2)) as avg_revenue_per_customer
into #rfm
FROM rfm_scores as rfm
INNER JOIN base ON base.customer_id = rfm.customer_id
GROUP BY (R + F + M) / 3 

select * from #rfm


--Select customer_id
	--	 ,CONCAT_WS(' - ', R, F, M) as rfm_cell	
		-- ,CAST((CAST(R as float) + F + M) / 3 as decimal(16, 2)) as avg_rfm_scores
--from rfm_scores
