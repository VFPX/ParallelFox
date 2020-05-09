* Custom callback object example
Set Path To "..;examples" Additive 
Local Parallel as Parallel of ParallelFox.vcx, loCallBack
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Clear 

loCallback = CreateObject("MyCallback")

Parallel.StartWorkers(FullPath("Custom_Callback.prg"),,.t.)

Parallel.CallMethod("Test", "MyObject", FullPath("Custom_Callback.prg"),,.t., loCallback)

Parallel.Wait()

? "Work Complete"

Parallel.StopWorkers()

Return 

DEFINE CLASS MyObject AS Custom

Procedure Test
	Lparameters loCallback
	Local lnUnits
	
	lnUnits = -1
	Do while lnUnits <> 0
		lnUnits = loCallback.GetMoreWork()
		This.RunUnits(lnUnits)
	EndDo 
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

DEFINE CLASS MyCallback AS Custom

nUnits = 0

Procedure GetMoreWork()

	If This.nUnits < 100
		This.nUnits = This.nUnits + 10
		? Program(), This.nUnits
		Return This.nUnits
	Else
		Return 0
	EndIf 

EndProc 

ENDDEFINE

