* Emulate Error() method handler
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

* Only one worker for this example
Parallel.SetWorkerCount(1)
Parallel.StartWorkers(FullPath("error_default.prg"))

Local loErrorHandler
loErrorHandler = CreateObject("MyErrorHandler")
Parallel.BindEvent("ReturnError", loErrorHandler, "HandlerError")

Parallel.Do("CauseError",, .t.)
Parallel.Wait()
Parallel.StopWorkers()

* Reset worker count to default
Parallel.SetWorkerCount(Parallel.CPUCount)

Procedure CauseError
	Error "Test Error"
EndProc 

Define Class MyErrorHandler as Custom
Procedure HandlerError
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
EndDefine