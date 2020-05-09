* Example calling method
Local i, lnTimer, loMyObject
Set Path To "..;examples" Additive 
Local Parallel as Parallel of ParallelFox.vcx
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Parallel.StartWorkers(FullPath("CallMethod_After.Prg"),,.t.)

lnTimer = Seconds()

For i = 1 to 10
	? "Running Units of Work", i * 10
	Parallel.CallMethod("Test", "MyObject", FullPath("CallMethod_After.prg"),,, i * 10)
EndFor 

Parallel.Wait()	
? "Total Time", Seconds() - lnTimer
Parallel.StopWorkers()

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
