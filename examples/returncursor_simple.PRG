* Simple example of returning cursor to main process
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

* Use only one worker for this example
Parallel.SetWorkerCount(1)
Parallel.StartWorkers(FullPath("returncursor_simple.prg"))
* Parallel.BindEvent("ReturnCursor", "Browse Last NoCaption NORMAL")

Parallel.Do("GetUSACustomers",,,Home())
Parallel.Wait()
Parallel.StopWorkers()

* USACustomers is open here
Select USACustomers
Browse Last NoCaption NORMAL 
Use in Select("USACustomers")

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

Procedure GetUSACustomers()
	Lparameters lcHomeDir
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	
	Select * from lcHomeDir + "Samples\Northwind\customers.dbf" where country = "USA" into cursor USACustomers
	Worker.ReturnCursor()
	Use in Select("USACustomers")
	Use in Select("Customers")
EndProc 