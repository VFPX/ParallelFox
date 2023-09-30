* UpdateProgress displays progress on thermometer in main process
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

Clear
* Use only one worker for this example
Parallel.SetWorkerCount(1)
Parallel.StartWorkers(FullPath("updateprogress_therm.prg"))

Local loThermometer as _thermometer of _therm.vcx
loThermometer = NewObject("_thermometer", "_therm.vcx","","Running Units...")
loThermometer.Show()
Parallel.BindEvent("UpdateProgress", loThermometer, "Update")
* Parallel.BindEvent("Complete", "Release loThermometer")

Parallel.Do("RunUnits",,,50)
Parallel.Wait()

Parallel.StopWorkers()

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

* Run specified units of work
Procedure RunUnits
	Lparameters lnUnits
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Local i
	For i = 1 to lnUnits
		SimulateWork()
		* UpdateProgress will be fired in main process every .5 seconds or longer
		Worker.ProgressInterval = 0.5
		Worker.UpdateProgress(i/lnUnits*100, Textmerge("Completed Units: <<i>> of <<lnUnits>>"))
	EndFor 	
EndProc 

Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 