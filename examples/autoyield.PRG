* Autoyield example. Toggle to see effect.
Lparameters llAutoYield
Local loMyObject, llPreviousAutoYield
Set Path To "..;examples" Additive 

Try
	llPreviousAutoYield = _VFP.AutoYield 

	_VFP.AutoYield = llAutoYield	&& toggle .T. to .F.

	clear
	loMyObject = CreateObject("MyObject")
	loMyObject.Test()
Finally
	_VFP.AutoYield = llPreviousAutoYield 
EndTry 

Return 

DEFINE CLASS MyObject AS Custom

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("AutoYield.prg"),,.t.)
	
	Parallel.BindEvent("Complete", This, "HandleComplete")
	
	lnTimer = Seconds()
	
	* Run code on workers
	For i = 1 to 10
		Parallel.CallMethod("RunUnits", This.Class, This.ClassLibrary,,,i*5)
	EndFor 

	* Run code in main process
	For i = 1 to 10
		This.RunUnits(i*5)
	EndFor 
	
	Parallel.Wait()
	? "Time", Seconds() - lnTimer
	Parallel.StopWorkers()
	
EndProc 

Procedure HandleComplete
	Lparameters lvReturn
	? Program(), lvReturn
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
	Return lnUnits
EndProc 

ENDDEFINE

