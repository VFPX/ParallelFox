* Complete event returns thread ID of each worker
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Clear 
Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("complete_threadid.prg"))

Local loMyHandler
loMyHandler = CreateObject("MyHandler")
* Must BindEvent BEFORE sending commmands to workers
Parallel.BindEvent("Complete", loMyHandler, "PrintThreadID")

Wait "Running code in parallel..." Window Nowait
Parallel.Call("GetThreadID", .t.)

Parallel.Wait()
Parallel.StopWorkers()
Wait clear
MessageBox("Code Complete.")

Procedure GetThreadID()
	Return _VFP.ThreadID
EndProc 

Define Class MyHandler as Custom
Procedure PrintThreadID
	* Event handler must accept one parameter containing the return value
	Lparameters lnThreadID

	? "Worker Thread ID:", lnThreadID
EndProc 
EndDefine 