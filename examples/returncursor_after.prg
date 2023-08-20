* ReturnCursor event example
Lparameters llNoBrowse	&& .T. for unit test
Local loMyObject
Set Path To "..;examples" Additive 
Clear 
loMyObject = CreateObject("MyObject")
loMyObject.lNoBrowse = llNoBrowse
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

lNoBrowse = .f.

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("ReturnCursor_After.prg"),,.t.)

	lnTimer = Seconds()
	
	Parallel.CallMethod("Query1",This.Class,This.ClassLibrary)
	Parallel.CallMethod("Query2",This.Class,This.ClassLibrary)
	Parallel.CallMethod("Query3",This.Class,This.ClassLibrary)
	Parallel.Wait()
	Parallel.StopWorkers()
	
	Select CustCsr.CustomerID, CustCsr.CompanyName, CustCsr.ContactName, ;
		OrderCsr.OrderID, OrderCsr.OrderDate, ;
		DetailCsr.ProductID, DetailCsr.Quantity, DetailCsr.UnitPrice ;
	from CustCsr ;
		join OrderCsr on OrderCsr.CustomerID = CustCsr.CustomerID ;
		join DetailCsr on DetailCsr.OrderID = OrderCsr.OrderID ;
	into cursor CustOrders
	
	? "Total Time", Seconds() - lnTimer
	
	If !This.lNoBrowse
		Browse Last NoCaption NORMAL 		
	EndIf 	
EndProc 

Procedure Query1
	Set Path To "..;examples" Additive 
	SET EXCLUSIVE Off
	Local Worker as Worker of ParallelFox.vcx
	Worker = NewObject("Worker", "ParallelFox.vcx")
	? Program()
	Select * from Home() + "Samples\Northwind\customers.dbf" into cursor CustCsr nofilter
	This.RunUnits(100)	&& simulate long running query
	Worker.ReturnCursor()
EndProc

Procedure Query2
	Set Path To "..;examples" Additive 
	SET EXCLUSIVE Off
	Local Worker as Worker of ParallelFox.vcx
	Worker = NewObject("Worker", "ParallelFox.vcx")
	? Program()
	Select * from Home() + "Samples\Northwind\Orders.dbf" into cursor OrderCsr nofilter
	This.RunUnits(100)	&& simulate long running query
	Worker.ReturnCursor()
EndProc

Procedure Query3
	Set Path To "..;examples" Additive 
	SET EXCLUSIVE Off
	Local Worker as Worker of ParallelFox.vcx
	Worker = NewObject("Worker", "ParallelFox.vcx")
	? Program()
	Select * from Home() + "Samples\Northwind\OrderDetails.dbf" into cursor DetailCsr nofilter
	This.RunUnits(100)	&& simulate long running query
	Worker.ReturnCursor()
EndProc

Procedure RunUnits
	Lparameters lnUnits
	Local i, lnSeconds
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
EndProc 

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

ENDDEFINE

