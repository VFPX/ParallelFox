* Progress example using thermometer form
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

oThermometer = NULL
nProgress = 0

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("ProgressForm.prg"))
	
	lnTimer = Seconds()

	Parallel.CallMethod("SimulateReport", This.Class, This.ClassLibrary)

EndProc 

Procedure SimulateReport
	Local lnPage	
	Set Path To "..;examples" Additive 
	For lnPage = 1 to 100
		This.UpdateProgress(lnPage, "Printing Report: Page " + Transform(lnPage) + " of 100")
		This.RunUnits(4)
	EndFor 
	This.UpdateProgress(100, "Report Complete", .t.)
EndProc 

Procedure UpdateProgress
	Lparameters lnPercent, lcMessage, llComplete

	If Vartype(This.oThermometer) <> "O"
		Sys(2335, 1)	&& disable unattended mode, allow UI
		This.oThermometer = NewObject("mytherm", "mytherm.vcx","","Running in Background")
		This.oThermometer.Show()
	EndIf 	
	If llComplete
		This.oThermometer.Complete(lcMessage)
	Else
		This.oThermometer.Update(lnPercent, lcMessage)
	EndIf 
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

