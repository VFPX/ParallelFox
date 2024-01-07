# In-Process Workers

ParallelFox 2.0 added support for in-process workers.  This allows workers to run in a multi-threaded DLL, rather than a separate EXE process.  To deploy, ParallelFoxMT.DLL should be installed and registered using RegSvr32 or your installer program.  DMult.DLL (created by Christof Wollenhaupt) should also be installed, but it does not require registration.