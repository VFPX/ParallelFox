* Complete event returns thread ID of each worker
* This example uses one-line command rather than object for Complete handler
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Clear 
Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("complete_command.prg"))

* Use command rather than object as handler.
* IMPORTANT: Local variables are not in scope of command.
* When using command, parameters returned from worker are named tPar1, tPar2, etc.
Parallel.BindEvent("Complete", [? "Worker Thread ID:", tPar1])

Wait "Running code in parallel..." Window Nowait
Parallel.Call("GetThreadID", .t.)

Parallel.Wait()
Parallel.StopWorkers()
Wait clear
MessageBox("Code Complete.")

Procedure GetThreadID()
	Return _VFP.ThreadID
EndProc 
