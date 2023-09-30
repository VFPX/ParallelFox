* Validate USA orders
Set Path To "..;EXAMPLES" Additive
Local loOrder
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

* Get USA order data
Select * from Home() + "Samples\Northwind\orders.dbf" ;
	where shipcountry = "USA" ;
	into cursor USAOrders
	
Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("validate_orders.prg"))

Wait "Validating orders..." window nowait
Select USAOrders
Scan
	Scatter Name loOrder Memo
	Parallel.Call("ValidateOrder",,loOrder)
EndScan
Use in Select("USAOrders")
Use in Select("Orders")

Parallel.Wait()
Parallel.StopWorkers()
Wait clear
MessageBox("Code Complete.")

Procedure ValidateOrder
	Lparameters loOrder
	* Simulate validation
	SimulateWork()
EndProc 

Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 