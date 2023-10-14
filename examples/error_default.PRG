* Use default error handler
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

* Error occurs on two workers and both will be reported
Parallel.SetWorkerCount(2)
Parallel.StartWorkers(FullPath("error_default.prg"))
Parallel.Do("CauseError",,.t.)
Parallel.Wait()
Parallel.StopWorkers()

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

Procedure CauseError
	Error "Test Error"
EndProc 