* Progress example using Desktop Alerts
* VFPAlerts must be registered to run this example
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

oAlert = NULL
nProgress = 0

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("ProgressAlert.prg"))
	
	lnTimer = Seconds()

	Parallel.CallMethod("SimulateReport", This.Class, This.ClassLibrary)

EndProc 

Procedure SimulateReport
	Local lnPage	
	For lnPage = 1 to 100
		This.UpdateProgress(lnPage, "Page " + Transform(lnPage) + " of 100")
		This.RunUnits(4)
	EndFor 
	This.UpdateProgress(100, "Report Complete", .t.)
EndProc 

Procedure UpdateProgress
	Lparameters lnPercent, lcMessage, llComplete

	If Type("_Screen.oAlertMgr") <> "O"
		_Screen.AddProperty("oAlertMgr")
		_Screen.oAlertMgr = CreateObject("VFPalert.AlertManager")
		This.oAlert = _Screen.oAlertMgr.NewAlert()
		This.oAlert.Alert("",64, "Printing Report", lcMessage)
	EndIf 	
	If Type("This.oAlert.oAlertForm.lblSubject") = "O"
		This.oAlert.oAlertForm.lblSubject.Caption = lcMessage
	EndIf 
	If llComplete
		If Type("This.oAlert.oAlertForm.lblSubject") <> "O"
			This.oAlert = _Screen.oAlertMgr.NewAlert()
			This.oAlert.Alert("",64, "Printing Report", "Report Complete")
		EndIf 
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

