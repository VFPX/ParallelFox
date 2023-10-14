* Basic flow for running code in parallel
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

*** Configure
* Set the number of desired workers.
* The default is 1 worker per logical CPU.
* Other settings are available.
Parallel.SetWorkerCount(8)

*** Start workers
* The first parameter cProcedureFile is required.
* It is the file that contains code to run inside workers.
* SET PROCEDURE TO cProcedureFile ADDITIVE will be performed in every worker when it is started.
* It is typically an APP or EXE, and is often the same APP/EXE that is used in the main process, 
* 	although it can be different.
* For examples or debugging, it can also be a PRG.
* In this case, the current program is used.
Parallel.StartWorkers(FullPath("basic_flow.prg"),,.f.)

*** Run code in parallel
* Each command will be queued and sent to a worker to run in parallel.
* Parallel.Do() is used here, but other ways to run code are available.
Wait "Running code in parallel..." Window Nowait
For lni = 1 to 80
	Parallel.Do("SimulateWork")
EndFor

*** Optionally wait for code to complete
* Program will wait until all commands sent to workers are complete.
Parallel.Wait()
Wait clear

*** Stop workers
* Closes worker processes and frees up resources
Parallel.StopWorkers()

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

MessageBox("Code Complete.")

Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 
