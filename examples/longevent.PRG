* Event handlers should be kept short
Lparameters llMessageBoxTimeout
Local loMyObject
Set Path To "..;examples" Additive 
loMyObject = CreateObject("MyObject")
loMyObject.lMessageBoxTimeout = llMessageBoxTimeout
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

lMessageBoxTimeout = .f.	&& .T. during unit test

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("LongEvent.prg"),,.t.)
	
	Parallel.BindEvent("Complete", This, "HandleComplete")
	
	lnTimer = Seconds()

	* Try running this on all workers by changing .f. parameter to .t.
	Parallel.CallMethod("RunUnits", This.Class, This.ClassLibrary,,.t.,10)

	Parallel.Wait()
	Parallel.StopWorkers()
EndProc 

Procedure HandleComplete
	Lparameters lvReturn
	If This.lMessageBoxTimeout && unit test
		MessageBox(Transform(lvReturn),0,"HandleComplete", 5000)
	Else 
		* This is bad.  Event could last forever.
		MessageBox(Transform(lvReturn),0,"HandleComplete")
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

