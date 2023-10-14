* Return multiple values to main process using ReturnData event.
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Clear 
Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("returndata_multiple.prg"))

* Use command rather than object as handler.
* IMPORTANT: Local variables are not in scope of command.
* When using command, parameters returned from worker are named tPar1, tPar2, etc.
Parallel.BindEvent("ReturnData", [? "Process:", tPar1, "Thread:", tPar2, "Unique:", tPar3])

Wait "Running code in parallel..." Window Nowait
Parallel.Call("GetWorkerInfo", .t.)

Parallel.Wait()
Parallel.StopWorkers()
Wait clear
MessageBox("Code Complete.")

Procedure GetWorkerInfo()
	Local Worker as Worker
	Worker = NewObject("Worker", "ParallelFox.vcx") 
	Worker.ReturnData(_VFP.ProcessId, _VFP.ThreadId, Sys(2015))
EndProc 
