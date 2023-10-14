* Stream data to main process as code runs in worker
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

Clear
* Use only one worker for this example
Parallel.SetWorkerCount(1)
Parallel.StartWorkers(FullPath("returndata_stream.prg"))

Parallel.BindEvent("ReturnData", [? "Number of Units:", tPar1, "Time to Run:", tPar2])

Parallel.Do("DoSomeWork")

* Since there is no Parallel.Wait(), the main process remains active for input while code runs in background.
* Workers will not be stopped until work is complete.
Parallel.StopWorkers()
* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

* Long running program in worker
Procedure DoSomeWork
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Local lnUnits, lnTimer
	For lnUnits = 1 to 10
		lnTimer = Seconds()
		RunUnits(lnUnits)
		Worker.ReturnData(lnUnits, Seconds() - lnTimer)
	EndFor 
EndProc 

* Run specified units of work
Procedure RunUnits
	Lparameters lnUnits
	Local i
	For i = 1 to lnUnits
		SimulateWork()
	EndFor 	
EndProc 

Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 