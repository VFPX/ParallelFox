* Validate USA orders in batches with cancellation
Set Path To "..;EXAMPLES" Additive
Local loOrder, lcTempTable, lnBatchSize
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

* Get USA order data
Clear 
Set Exclusive Off 
Select * from Home() + "Samples\Northwind\orders.dbf" ;
	where shipcountry = "USA" ;
	into cursor USAOrders

Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("validate_cancel.prg"))

* Display each order validated
Parallel.BindEvent("ReturnData", "? tPar1")

Wait "Validating orders..." window nowait
Select USAOrders
* Create temp table
lcTempTable = Parallel.CreateTempTable("USAOrders")
* Open temp table in all workers
Parallel.Call("OpenTempTable", .t., lcTempTable)

* Validate a batch of records with each call
lnBatchSize = 10
For lnRecord = 1 to Reccount() Step (lnBatchSize)
	Parallel.Call("ValidateBatch",,lnRecord, lnRecord + lnBatchSize - 1)
EndFor 
Use in Select("USAOrders")
Use in Select("Orders")

MessageBox("Press OK to Cancel")
Parallel.Cancel()

* Close temp table in all workers
Parallel.Call("CloseTempTable", .t., "USAOrders")

Parallel.Wait()
Parallel.StopWorkers()
* Clean up - delete temp table
Parallel.DeleteTempTable(lcTempTable)
Wait clear
MessageBox("Code Complete.")

Procedure OpenTempTable
	Lparameters lcTempTable
	Set Exclusive Off
	Set Reprocess To Automatic
	Use in Select("USAOrders")
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Worker.OpenTempTable(lcTempTable, "USAOrders")	
EndProc 

Procedure ValidateBatch
	Lparameters lnStartRecord, lnEndRecord
	Local loRecord
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Select USAOrders
	Go lnStartRecord
	Scan while Recno() <= lnEndRecord
		If Worker.IsCancelled()
			Worker.ReturnData("Worker Process Cancelled.")	
			Exit 
		Else 
			Scatter Name loOrder Memo
			ValidateOrder(loOrder)
			Worker.ReturnData("Validated Order " + Transform(loOrder.OrderID))	
		EndIf 
	EndScan 
EndProc 

Procedure ValidateOrder
	Lparameters loOrder
	* Simulate validation
	SimulateWork()
EndProc 

Procedure CloseTempTable
	Lparameters lcAlias
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Worker.CloseTempTable(lcAlias)
EndProc 

Procedure SimulateWork
	Local i
	For i = 1 to 100000000
		* Peg CPU
	EndFor
EndProc 