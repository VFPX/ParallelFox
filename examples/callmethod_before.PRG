* Example calling method
Local i, lnTimer, loMyObject
Set Path To "..;examples" Additive 

lnTimer = Seconds()

For i = 1 to 10
	? "Running Units of Work", i * 10
	loMyObject = NewObject("MyObject", "CallMethod_Before.prg")
	loMyObject.Test(i * 10)
EndFor 
	
? "Total Time", Seconds() - lnTimer

Return 

DEFINE CLASS MyObject AS Custom

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

Procedure Test
	Lparameters lnUnits
	Local i
	? Program(), lnUnits	
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	

EndProc 

ENDDEFINE
