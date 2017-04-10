* Make sure variables in your event handlers are local
Local loMyObject
Set Path To "..;examples" Additive 
clear
loMyObject = CreateObject("MyObject")
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

Procedure Test
	Local i, lnTimer, loMyObject
	Local Parallel as Parallel of ParallelFox.vcx
	Parallel = NewObject("Parallel", "ParallelFox.vcx")

	Parallel.StartWorkers(FullPath("LocalVars.prg"),,.t.)
	
	Parallel.BindEvent("Complete", This, "HandleComplete")
	
	lnTimer = Seconds()
	
	* Run code on workers
	For i = 1 to 10
		Parallel.CallMethod("RunUnits", This.Class, This.ClassLibrary,,,10)
	EndFor 

	Parallel.Wait()
	? "Time", Seconds() - lnTimer
	
EndProc 

Procedure HandleComplete
	Lparameters lvReturn
	Local i
	* Comment/uncomment line below to see how results change
	Local j
	j = 0
	? Program(), "Start"
	For i = 1 to 5
		j = j + 1 
		? "i =", i, "j =", j
		This.RunUnits(10)
	EndFor 
	? Program(), "End"
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
*	? Program(), lnUnits
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
	Return lnUnits
EndProc 

ENDDEFINE

