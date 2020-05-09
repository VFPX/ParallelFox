* Progress example using status bar
Lparameters llWait && .T. for unit test
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")

If Vartype(_Screen.oMyHandler) = "O"
	_Screen.RemoveObject("oMyHandler")
EndIf 
_Screen.AddObject("oMyHandler", "MyHandler")

loMyObject.lWait = llWait
loMyObject.Test()


Return 

Define Class MyHandler as Custom

Procedure DisplayProgress
	Lparameters lnPercent, lcMessage

	_VFP.StatusBar = lcMessage + " (" + Transform(lnPercent) + "%)"

EndProc 

Procedure Cleanup
	Lparameters lvReturn
	If Vartype(_Screen.oMyHandler) = "O"
		_Screen.RemoveObject("oMyHandler")
	EndIf 
EndProc 
EndDefine 


DEFINE CLASS MyObject AS Custom

lWait = .f.	&& .T. for unit test

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("ProgressEvent.prg"))

	Parallel.BindEvent("UpdateProgress", _Screen.oMyHandler, "DisplayProgress")
	Parallel.BindEvent("Complete", _Screen.oMyHandler, "Cleanup")
	
	lnTimer = Seconds()

	Parallel.CallMethod("SimulateReport", This.Class, This.ClassLibrary)

	If This.lWait	&& for unit test, wait until finished
		Parallel.Wait()
	EndIf 
	
	Parallel.StopWorkers()

EndProc 

Procedure SimulateReport
	Local lnPage	
	Local Worker as Worker of ParallelFox.vcx
	Worker = NewObject("Worker", "ParallelFox.vcx") 

	For lnPage = 1 to 100
		Worker.UpdateProgress(lnPage, "Printing Report: Page " + Transform(lnPage) + " of 100")
		This.RunUnits(4)
	EndFor 
	Worker.UpdateProgress(100, "Report Complete", .t.)
EndProc 

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

Procedure RunUnits
	Lparameters lnUnits
	Local i
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
EndProc 

ENDDEFINE

