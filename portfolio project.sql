
--Data cleaning

--converting negative values to positive 

update [PortfolioProject ].[dbo].[Online Retail]
set Quantity = case when Quantity >0 then Quantity* 1 else Quantity* -1 end 
from [PortfolioProject ].[dbo].[Online Retail]

--missing values in description

update a
set Description=ISNULL (a.Description, b.Description) 
from [PortfolioProject ].[dbo].[Online Retail] a
join [PortfolioProject ].[dbo].[Online Retail] b
on a.StockCode= b.StockCode
and a.[ID] <> b.ID
where a.Description is null

--missing values in Customer ID
--
update  a
set CustomerID=ISNULL(a.CustomerID, b.CustomerID)
from [PortfolioProject ].[dbo].[Online Retail] a 
join [PortfolioProject ].[dbo].[Online Retail] b
on a.Country = b.Country
and a.ID <> b.ID
where a.CustomerID is null

update [PortfolioProject ].[dbo].[Online Retail] 
set CustomerID=ISNULL (CustomerID,0) 

--Unit Price missing values 

update a 
set 
UnitPrice=ISNULL( a.UnitPrice, b.UnitPrice )
from [PortfolioProject ].[dbo].[Online Retail] a
join [PortfolioProject ].[dbo].[Online Retail] b
on a.StockCode =b.StockCode 
where a. UnitPrice IS NULL

--------------------------------------------------------------------------------------------------------------------------------------------
--Data exploration
-----------------------------------------------
--frequently bought toghether items

select top (1000) T1.InvoiceNo, T1.Description, T1.Quantity, T2.Description, T2.Quantity from [PortfolioProject ].[dbo].[Online Retail] T1
join [PortfolioProject ].[dbo].[Online Retail] T2 on T1.InvoiceNo = T2.InvoiceNo
where T1.Description > T2.Description

-- shows the amount each customer spent in one purchase 

select InvoiceNo, SUM(Quantity *UnitPrice) as sumOfPounds_Purchases, CustomerID, StockCode,
case when StockCode IS NULL then 'TOTAL' else '' end Subtotals
from [PortfolioProject ].[dbo].[Online Retail]
group by InvoiceNo ,CustomerID,rollup(StockCode,Quantity*UnitPrice)


-- sum of sales per month

select  year(InvoiceDate) as year , month(InvoiceDate) as month,
Sum(UnitPrice*Quantity) as sumPurchases
from [PortfolioProject ].[dbo].[Online Retail]
group by Year(InvoiceDate), Month(InvoiceDate)
order by  year , month 

-- customers who only bought 1 product 

select distinct InvoiceNo, Quantity, CustomerID, InvoiceDate
from [PortfolioProject ].[dbo].[Online Retail]
where Quantity = 1

--sum of purchases per country with condition where country like RSA

select  SUM(UnitPrice*Quantity) as SumPerCountryEuros, Country
from [PortfolioProject ].[dbo].[Online Retail]
--where Country like 'RSA%'
group by   Country
order by SumPerCountryEuros DESC, Country

--Item popularity per Country

select count( StockCode)as Popular , Country, Description
from [PortfolioProject ].[dbo].[Online Retail]
group by Country, Description
order by Popular DESC