* Complete event example
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

	Parallel.StartWorkers(FullPath("Complete_After.prg"),,.t.)
	Parallel.BindEvent("Complete", This, "IncrementProgress")

	lnTimer = Seconds()

	For i = 1 to 10
		Parallel.CallMethod("RunUnits", This.Class, This.ClassLibrary,,,i * 10)
	EndFor 
	Parallel.Wait()
	This.UpdateProgress(100, "Process Complete.", .t.)	
	? "Total Time", Seconds() - lnTimer
	Parallel.StopWorkers()
EndProc 

Procedure IncrementProgress()
	Lparameters lvReturn
	This.nProgress = This.nProgress + 10
	This.UpdateProgress(This.nProgress, "Running units of work...")	
EndProc 

Procedure UpdateProgress
	Lparameters lnPercent, lcMessage, llComplete

	If Vartype(This.oThermometer) <> "O"
		This.oThermometer = NewObject("_thermometer", Home() + "\FFC\_THERM.VCX","","Events Test")
		This.oThermometer.Visible = .t.
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
	? Program(), lnUnits
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
EndProc 

ENDDEFINE

