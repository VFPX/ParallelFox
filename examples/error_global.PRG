* Use global error handler
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

* Configure global error handler
Parallel.OnError("Do MyErrorHandler with nError, cMethod, nLine, cMessage, cCode")
* Only one worker for this example
Parallel.SetWorkerCount(1)
Parallel.StartWorkers(FullPath("error_default.prg"))
Parallel.Do("CauseError",, .t.)
Parallel.Wait()
Parallel.StopWorkers()

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)
* Reset default global error handler
Parallel.OnError("This.DisplayErrors(nError, cMethod, nLine, cMessage, cCode)")

Procedure CauseError
	Error "Test Error"
EndProc 

Procedure MyErrorHandler
	Lparameters nError, cMethod, nLine, cMessage, cCode
	Local lcError
	Text to lcError TextMerge NoShow PreText 1+2
		Error: <<nError>> - <<cMessage>>
		Method/Procedure: <<cMethod>>
		Line: <<nLine>>
		Code: <<cCode>>	
	EndText 
	MessageBox(lcError, 16, "Error")
EndProc 