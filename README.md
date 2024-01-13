# ParallelFox
**Parallel Processing Library for Visual FoxPro**

Project Manager: [Joel Leach](https://github.com/JoelLeach)

ParallelFox is a parallel processing library for Visual FoxPro 9.0.

Although parallel processing and multi-threading have been possible in VFP for quite some time (particularly in web servers), the goal of this project is the same as parallel processing libraries that have been popping up for other development platforms. That is, to make parallel processing easier and more approachable, without all of the headaches typically associated with multi-threaded programming. This has become more important as multi-core desktop and server machines have become widespread.

## Documentation
ParallelFox includes complete documentation (ParallelFox.chm).  The Help file is designed to be used in conjunction with the training videos below. Use the Help file as a quick reference or short overview of topics. Watch the training videos for more in-depth discussions, examples, and techniques.

ParallelFox also takes advantage of Doug Hennig's [Favorites for IntelliSense](https://doughennig.com/papers.aspx), which Doug also used in the [MY project for Sedna](https://github.com/VFPX/My). This greatly simplifies the ParallelFox interfaces and provides extra details while you are coding. 

### New in 2
The Help file has not been updated with new features in ParallelFox 2.0. A brief description of each new feature with examples can be found on the [New in 2](NewIn2.md) page.

ParallelFox 2.0 was also presented at Southwest Fox 2023. The whitepaper and video of that session will be released at a later date.

## VFP Advanced
ParallelFox 2.0 includes limited support for VFP Advanced. For more details, see the [VFP Advanced Support](vfpa/README.md) page.

## Installation
These instructions assume that Visual FoxPro and the VFP runtimes have been properly installed and registered on your development machine.

**FoxGet**

The easiest way to install ParallelFox is to use Doug Hennig's [FoxGet Package Manager](https://github.com/DougHennig/FoxGet). FoxGet downloads only the files necessary to use ParallelFox, runs install.prg, and adds files to your project. FoxGet can be installed using Thor Check for Updates or directly from the GitHub repository. 

If you want to download all ParallelFox files, including the Help file and examples, use Manual Installation.

**Manual Installation**

- Download and unzip the latest stable release from the Releases page. Grab **ParallelFox_x.x.zip**, rather than the Source Code zip file GitHub automatically creates.
  - Alternatively, you can clone the repository or download the latest files, although this may contain experimental/unstable changes. As a minimum, you need all files in the root ParallelFox folder, as well as the **ffi** subdirectory.  
- **DO INSTALL** to register ParallelFox.exe and install the IntelliSense scripts.  
- See the "Installation" topic in the Help file for details.
## Training Videos
These videos are now available on YouTube: [ParallelFox Training Videos](https://www.youtube.com/watch?v=lXPrgN4CQs0&list=PLiJ9w2ByRUjYVO4mBFWgIW01ucjVpfQcQ). The previous videos are still available below.

**Introduction** [Flash](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Intro/ParallelFox_Intro.html) [WMV](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Intro/ParallelFox_Intro.wmv)
Errata: In this video, I said that CPU speeds topped out a 3-4 "Megahertz", which was about the speed of my first computer, a [PCjr](http://en.wikipedia.org/wiki/Pcjr).  I should have said "Gigahertz".  It's only a thousand-fold difference. :)

**Running Code in Parallel** [Flash](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Code/ParallelFox_Code.html) [WMV](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Code/ParallelFox_Code.wmv)

****Worker Events****
- Part 1 [Flash](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Events/ParallelFox_Events.html) [WMV](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Events/ParallelFox_Events.wmv)
- Part 2 [Flash](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Events_2/ParallelFox_Events_2.html) [WMV](http://www.mbs-intl.com/vfpx/parallelfox/ParallelFox_Events_2/ParallelFox_Events_2.wmv)