* Various ways to run code in workers
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

Wait "Starting workers..." Window Nowait
Parallel.StartWorkers(FullPath("running_code.prg"))

Wait "Running code in parallel..." Window Nowait

* Execute a single command on worker.
* lAllWorkers parameter .T. indicates command will run on all workers before any 
*	 subsequent code.
Parallel.DoCmd("Set Exclusive Off", .t.)

* Execute a program or procedure on worker using the DO command.
* Parameters can be passed to the program.
Parallel.Do("RunUnits",,,10)

* Execute/call a function on worker.  
* This can be an internal VFP function
Parallel.Call("Version",,1)
* ... or a user-defined function of our own.
* Unlike Do(), Call() has a return value.
Parallel.Call("RunUnits",,10)

* Execute/call a class method on worker.
* ParallelFox will instantiate cClassName on the worker, call cMethod, 
*	then release the object.
Parallel.CallMethod("RunUnits", "MyClass", FullPath("Running_Code.prg"),,,10)

* Execute a script on worker.
Local lcScript
Text to lcScript NoShow
	Lparameters lnUnits
	RunUnits(lnUnits * 2)
EndText 
Parallel.ExecScript(lcScript,,10)

Parallel.Wait()
Wait clear 
Parallel.StopWorkers()
MessageBox("Code Complete.")

* Run specified units of work
Procedure RunUnits
	Lparameters lnUnits
	Local i
	For i = 1 to lnUnits
		SimulateWork()
	EndFor 	
EndProc 

Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 

* Code can be in class 
Define Class MyClass as Custom
Procedure RunUnits
	Lparameters lnUnits
	Local i
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
EndProc 
Procedure SimulateWork
	Local i
	For i = 1 to 10000000
		* Peg CPU
	EndFor
EndProc 
EndDefine 
