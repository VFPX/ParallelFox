* DoCmd and ExecScript example
Local i, lnTimer, loMyObject

lnTimer = Seconds()

loMyObject = CreateObject("MyObject")
For i = 1 to 10
	? "Running Units of Work", i * 5
	loMyObject.nUnits = i * 5
	loMyObject.Test1()
	loMyObject.Test2()
EndFor 
	
? "Total Time", Seconds() - lnTimer

Return 

DEFINE CLASS MyObject AS Custom

nUnits = 0

Procedure Init()
	? "Running Init..."
	For i = 1 to 40
		This.SimulateWork()
	EndFor 	
EndProc 

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

Procedure Test1
	Local i
	? Program(), This.nUnits	
	For i = 1 to This.nUnits
		This.SimulateWork()
	EndFor 	
EndProc 

Procedure Test2
	Local i, lnUnits
	lnUnits = Round(This.nUnits/2,0)
	? Program(), lnUnits	
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
EndProc 

ENDDEFINE

