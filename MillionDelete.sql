	*** Deleting millions of rows in one transaction can throttle a SQL Server ***
--------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE – We will presume that in this example TRUNCATE TABLE is not available due to permissions, 
that foreign keys prevent this operation from being executed or that this operation is unsuitable for purpose 
because we don’t want to remove all rows.
--------------------------------------------------------------------------------------------------------------
When you run something like the following to remove all rows from your table in a single transaction,
	DELETE FROM ExampleTable
SQL Server sets about the process of writing to the transaction log all of the changes to be applied to the physical data. 
It will also decide on how it lock the data. It’s highly likely that the optimizer will decide 
that a complete table lock will be the most efficient way to handle the transaction.

There are potentially some big problems here,

    --Your transaction log may grow to accommodate the changes being written to it. 
    If your table is huge, you run the risk of consuming all the space on your transaction log disk.
    
    --If your application(s) still requires access to the table and a table lock has been placed on it, 
    your application has to wait until the table becomes available. 
    This could be some time resulting in application time outs and frustrated users.
    
    --Your transaction log disk will be working hard during this period as your transaction log grows. 
    This could be decreasing performance across all databases which might be sharing that disk for their transaction logs.
    
    --Depending on how much memory you have allocated to your SQL Server buffer pool,
    there could be significant drops in page life expectancy, reducing performance for other queries.
    
    --The realisation that a big performance issue is occurring lends temptation to kill the query. 
    The trouble with that is it can delay things even more as the server has to rollback the transaction. 
    Depending on how far along the operation is, this could add on even more time to what was originally going to be.

For example, if you kill the query and it is 90% done then the server has to rollback a 90% completed transaction. 
This will vary but the rollback can take as much time as the delete operation was in progress! (check using KILL n WITH STATUSONLY)
Some ways to delete millions of rows using T-SQL loops and TOP

Use a loop combined with TOP and delete rows in smaller transactions. Here are a couple of variations of the same thing. 
Note that I have arbitrarily chosen 1000 as a figure for demonstration purposes.

	SELECT 1
	WHILE @@ROWCOUNT > 0
	BEGIN
	DELETE TOP (1000)
	FROM LargeTable
	END

And another way…

	DoItAgain:
	DELETE TOP (1000)
	FROM ExampleTable
	IF @@ROWCOUNT > 0
	GOTO DoItAgain

These are simple examples just to demonstrate. You can add WHERE clauses and JOINS to help with the filtering process 
to remove specifics. You would add error handling/transactions (COMMIT/ROLLBACK)  also.

Summary
--It’s a bad idea to delete millions of rows in one transaction :) and whilst this might sound like a no-brainer, 
people do try and do this and wonder why things start to go bad.
--Breaking the delete operation down into smaller transactions is better all round. 
This will help reduce contention for your table, reduce probability of your transaction log 
becoming too large for its disk and reduce performance impact in general.
--Your transaction log disk will still be working hard as your refined delete routine removes the rows from your table. 
Try and run this task during maintenance windows which are typically done inside off peak periods.
