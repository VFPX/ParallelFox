* Progress example using thermometer form
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")

_Screen.AddObject("oMyHandler", "MyHandler")

loMyObject.Test()


Return 

Define Class MyHandler as Custom

Procedure DisplayProgress
	Lparameters lnPercent, lcMessage

	_VFP.StatusBar = lcMessage + " (" + Transform(lnPercent) + "%)"

EndProc 

EndDefine 


DEFINE CLASS MyObject AS Custom

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("ProgressEvent.prg"))

	Parallel.BindEvent("UpdateProgress", _Screen.oMyHandler, "DisplayProgress")
	
	lnTimer = Seconds()

	Parallel.CallMethod("SimulateReport", This.Class, This.ClassLibrary)

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

