* Event handlers should be kept short
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("LongEvent.prg"),,.t.)
	
	Parallel.BindEvent("Complete", This, "HandleComplete")
	
	lnTimer = Seconds()

	* Try running this on all workers by changing .f. parameter to .t.
	Parallel.CallMethod("RunUnits", This.Class, This.ClassLibrary,,.f.,10)

	Parallel.Wait()
EndProc 

Procedure HandleComplete
	Lparameters lvReturn
	* This is bad.  Event could last forever.
	MessageBox(Transform(lvReturn),0,"HandleComplete")
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

