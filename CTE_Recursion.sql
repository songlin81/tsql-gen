with CTE_Employee_hierarchy as (

    select E.EmployeeID, E.ReportsTo as Supervisor, E.FirstName, E.LastName
    from Employees E
    where E.EmployeeID = 5
    
    union all
    
    select E1.EmployeeID, E1.ReportsTo as Supervisor, E1.FirstName, E1.LastName
    from CTE_Employee_hierarchy
    join Employees E1
    on E1.ReportsTo=CTE_Employee_hierarchy.EmployeeID
    
)
select * from CTE_Employee_hierarchy
