* ReturnCursor event example
Lparameters llNoBrowse	&& .T. for unit test
Local loMyObject
Clear 
loMyObject = CreateObject("MyObject")
loMyObject.lNoBrowse = llNoBrowse
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

lNoBrowse = .f.

Procedure Test
	Local i, lnTimer, loMyObject

	lnTimer = Seconds()
	
	This.Query1()
	This.Query2()
	This.Query3()
	
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
	? Program()
	Select * from Home() + "Samples\Northwind\customers.dbf" into cursor CustCsr nofilter
	This.RunUnits(100)	&& simulate long running query
EndProc

Procedure Query2
	? Program()
	Select * from Home() + "Samples\Northwind\Orders.dbf" into cursor OrderCsr nofilter
	This.RunUnits(100)	&& simulate long running query
EndProc

Procedure Query3
	? Program()
	Select * from Home() + "Samples\Northwind\OrderDetails.dbf" into cursor DetailCsr nofilter
	This.RunUnits(100)	&& simulate long running query
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

