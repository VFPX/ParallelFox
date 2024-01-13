# New in 2
### New Features in ParallelFox 2.0

Several features have been added with the release of ParallelFox 2.0:

**In-process Workers**

ParallelFox typically uses out-of-process EXEs for the workers. Version 2.0 includes the option to use in-process workers via a multi-threaded DLL.  See [out_vs_in_process.prg](examples/out_vs_in_process.PRG).

**Single-command event handler**

ParallelFox 2.0 allows a single command to be passed as a string to the second parameter of BindEvent(), rather than requiring an object as the event handler.  See [complete_command.prg](examples/complete_command.prg).

**Reg-Free COM**

ParallelFox 2.0 includes the option to use “reg-free COM”, which means it can launch your workers without registering ParallelFox.exe.  See [regfreecom.prg](examples/regfreecom.prg).

**Named Instances**

ParallelFox 2.0 includes the ability to have separate named instances.  Each instance is completely independent and has a separate queue with its own set of workers and events. See [multiple_instances.prg](examples/multiple_instances.prg).

**Temporary Tables**

ParallelFox 2.0 introduces Parallel.CreateTempTable() to create a temporary table from a cursor in the main process/thread.  That table can be opened in workers using Worker.OpenTempTable(). See [validate_batch.prg](examples/validate_batch.prg).


**Process Cancellation**

ParallelFox 2.0 adds the ability to cancel parallel processing that is currently in progress. See [validate_cancel.prg](examples/validate_cancel.prg).

