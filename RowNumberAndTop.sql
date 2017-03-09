How to Select Top N Rows for Each Group Using ROW_NUMBER() 

    SELECT SalesOrderID
        ,OrderDate
        ,SalesOrderNumber
        ,AccountNumber
        ,CustomerID
        ,SubTotal
        ,TaxAmt
        ,TotalDue
    FROM [AdventureWorks2012].[Sales].[SalesOrderHeader]
    ORDER BY CustomerID, OrderDate DESC

-->

    SELECT SalesOrderID
        ,OrderDate
        ,SalesOrderNumber
        ,AccountNumber
        ,CustomerID
        ,SubTotal
        ,TaxAmt
        ,TotalDue
        ,ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CustomerID, OrderDate DESC) AS RowNum
    FROM [AdventureWorks2012].[Sales].[SalesOrderHeader]

-->

    WITH MyRowSet
    AS
    (
        SELECT SalesOrderID
            ,OrderDate
            ,SalesOrderNumber
            ,AccountNumber
            ,CustomerID
            ,SubTotal
            ,TaxAmt
            ,TotalDue
            ,ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CustomerID, OrderDate DESC) AS RowNum
        FROM [AdventureWorks2012].[Sales].[SalesOrderHeader]
    )
    SELECT * FROM MyRowSet WHERE RowNum <= 2

--------------------------------------------------------------------------------------------------

-->
    select * from (
        select (ROW_NUMBER() OVER(order by IDesc)) as rownum, * from TableX
    ) t 
    where rownum between 1 and 20

--> 
    select Identity(int, 1, 1) as ID_Num, * into #temp from tableX
    select * from #temp where ID_num between 10 and 20
