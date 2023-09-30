* Use registration-free COM for EXE workers
Local Parallel as Parallel
Parallel = NewObject("Parallel", "ParallelFox.vcx")

* You can run ParallelFox.exe /unregserver to unregister for testing

Parallel.SetRegFreeCOM(.t.)
Parallel.StartWorkers(FullPath("RegFreeCom.prg"))

MessageBox("Workers are now running.")

Parallel.StopWorkers()
Parallel.SetRegFreeCOM(.f.)

* Run ParallelFox.exe /regserver to re-register
