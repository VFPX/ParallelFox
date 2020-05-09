* DoCmd and ExecScript example
Local i, lnTimer, loMyObject
Set Path To "..;examples" Additive 
Local Parallel as Parallel of ParallelFox.vcx
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Parallel.StartWorkers(FullPath("DoCmdScript_After.prg"),,.t.)

lnTimer = Seconds()

Parallel.DoCmd([Set Path To "..;examples" Additive],.t.)
Parallel.DoCmd([_Screen.NewObject("oMyObject","MyObject", "DoCmdScript_After.prg")], .t.)
For i = 1 to 10
	? "Running Units of Work", i * 5

	Text to cScript Noshow
	Lparameters i
	_Screen.oMyObject.nUnits = i * 5
	_Screen.oMyObject.Test1()
	_Screen.oMyObject.Test2()
	EndText 

	Parallel.ExecScript(cScript,,i)
EndFor 
Parallel.DoCmd([_Screen.RemoveObject("oMyObject")], .t.)	

Parallel.Wait()
? "Total Time", Seconds() - lnTimer
Parallel.StopWorkers()

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

Procedure Destroy()
	? Program()
EndProc 	

ENDDEFINE

