* Compare out-of-process EXE to in-process DLL workers
Set Path To "..;EXAMPLES" Additive
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx") 

* Out of process workers use ParallelFox.exe
Parallel.SetMultiThreaded(.f.)
Parallel.StartWorkers(Program())
MessageBox("Check ParallelFox.exe in Task Manager.")
Parallel.StopWorkers()

* In process use ParallelFoxMT.dll
MessageBox("Check VFP9.exe number of threads in Task Manager before workers started.")
Parallel.SetMultiThreaded(.t.)
Parallel.StartWorkers(Program())
MessageBox("Check VFP9.exe number of threads again.")
Parallel.StopWorkers()
Parallel.SetMultiThreaded(.f.)