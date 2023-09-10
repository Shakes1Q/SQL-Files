select * from sales s 
where GeoID = 'G4' and Amount > 15000

select * from geo g

select s.* from sales s 
join geo g on g.GeoID = s.GeoID
where g.Geo ='Canada';


select * from sales s 
where Boxes < 50;

select * from sales s
where SaleDate >= '2021-01-01' and SaleDate < '2021-02-01';








