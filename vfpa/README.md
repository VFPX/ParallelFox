# VFP Advanced Support

[VFP Advanced](http://baiyujia.com/vfpadvanced/default.asp) patches VFP 9.0 SP2 to fix bugs and add features, such as DBFs greater than 2GB and 64-bit support.  It was created by a member of the FoxPro community: Chuanbing Chen from Shenzen, China. While many Fox devs continue to use VFP 9, popularity for VFP Advanced has been growing.  ParallelFox intends to support VFP Advanced, but it is a work in progress.  Here is the current status as of this writing:

- VFPA 10.0 32-bit works with out-of-process workers. ParallelFox\VFPA\ParallelFoxA.exe should be distributed and registered (or use reg-free COM).
- Out-of-process workers may also work with VFPA 32-bit 10.1 and 10.2, but it has not been tested.  This would require recompiling ParallelFoxA.exe in that version of VFPA.
- VFPA 10.0 32-bit works with in-process workers, but those workers currently use the VFP 9 runtime.  In my testing, in-process workers did not work when using the VFPA 10.0 MTDLL runtime.  This means VFPA features will not be available within in-process workers.  Distribute ParallelFoxMT.dll for this scenario.
- VFPA 10.0 64-bit does not work with out-of-process or in-process workers.
