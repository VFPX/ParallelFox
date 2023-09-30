* Multiple instances
Set Path To "..;EXAMPLES" Additive
Wait "Starting workers..." Window Nowait

* Default instance uses out-of-process workers
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")
Parallel.StartWorkers(FullPath("multiple_instances.prg"))

* Second instance uses in-process workers
* Since in the same prg, Parallel reference must be a different name
Local Parallel2 as Parallel
Parallel2 = NewObject("Parallel", "ParallelFox.vcx")
* Set instance name before other settings and starting workers
Parallel2.SetInstance("INPROCESS")
Parallel2.SetMultiThreaded(.t.)
Parallel2.StartWorkers(FullPath("multiple_instances.prg"))

* Do work in both instances simultaneously
Wait "Running code in parallel..." Window Nowait
Parallel.Do("RunUnits",,,10)
Parallel2.Do("RunUnits",,,10)

Parallel.Wait()
Parallel2.Wait()

Parallel.StopWorkers()
Parallel2.StopWorkers()
Wait clear 
MessageBox("Code Complete.")

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