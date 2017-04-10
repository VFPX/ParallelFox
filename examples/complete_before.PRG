* Complete event example
Local loMyObject
loMyObject = CreateObject("MyObject")
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

oThermometer = NULL

Procedure Test
	Local i, lnTimer, loMyObject

	lnTimer = Seconds()

	For i = 1 to 10
		This.RunUnits(i * 10)
		This.UpdateProgress(i * 10, "Running units of work...")
	EndFor 
	This.UpdateProgress(100, "Process Complete.", .t.)	
	? "Total Time", Seconds() - lnTimer
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

