* Steps example
Lparameters llNoBrowse
Local lnTimer, lnUnits
Set Path To "..;examples" Additive 
Local Parallel as Parallel of ParallelFox.vcx
Parallel = NewObject("Parallel", "ParallelFox.vcx")

Parallel.StartWorkers(FullPath("Steps_After.prg"),,.t.)

Clear 
Erase StepsLog.DBF
Create Table StepsLog (cProgram C(20), nUnits I, nSeconds N(8,2))

lnTimer = Seconds()

? "Running Step 1..."
lnUnits = Step1(4)
? "Running Step 2..."
Parallel.Do("Step2",,,lnUnits)
? "Running Step 3..."
Parallel.Do("Step3",,,lnUnits)
? "Running Step 4..."
Parallel.Do("Step4",,,lnUnits)
Parallel.Wait()
? "Running Step 5..."
Do Step5 with lnUnits

? "Total Time", Seconds() - lnTimer

If !Used("StepsLog")
	Use StepsLog In 0
EndIf 	
Select StepsLog
If !llNoBrowse	&& .T. for unit test
	Browse Last NoCaption NORMAL 
EndIf 
Use 
Erase StepsLog.dbf

Parallel.StopWorkers()

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

* Count units of work that can be done in specified seconds
Function Step1(lnSeconds)
	Local lnTimer, lnUnits

	lnUnits = 0
	lnTimer = Seconds()
	Do while Seconds() - lnTimer < lnSeconds
		lnUnits = lnUnits + 1 
		SimulateWork()
	EndDo 

	LogResults(Program(), lnUnits, Seconds() - lnTimer)
	Return lnUnits
EndFunc 

* Run twice as many units
Procedure Step2
	Lparameters lnUnits
	Local lnTimer, i, lnTotalUnits
	? Program()	
	lnTimer = Seconds()
	lnTotalUnits = lnUnits * 2
	For i = 1 to lnTotalUnits
		SimulateWork()	
	EndFor 

	LogResults(Program(), lnTotalUnits, Seconds() - lnTimer)
EndProc 

* Run half as many units
Procedure Step3
	Lparameters lnUnits
	Local lnTimer, i, lnTotalUnits
	? Program()	
	lnTimer = Seconds()
	lnTotalUnits = Round(lnUnits/2, 0)
	For i = 1 to lnTotalUnits
		SimulateWork()	
	EndFor 

	LogResults(Program(), lnTotalUnits, Seconds() - lnTimer)
EndProc 

* Run 1.5X units plus 2
Procedure Step4
	Lparameters lnUnits
	Local lnTimer, i, lnTotalUnits
	? Program()	
	lnTimer = Seconds()
	lnTotalUnits = Round(lnUnits * 1.5, 0) + 2
	For i = 1 to lnTotalUnits
		SimulateWork()	
	EndFor 

	LogResults(Program(), lnTotalUnits, Seconds() - lnTimer)
EndProc 

* Add up all previous units and divide by 3
Procedure Step5
	Lparameters lnUnits
	Local lnTimer, i, lnTotalUnits
	
	lnTimer = Seconds()

	Select Sum(lnUnits) as TotalUnits from StepsLog into cursor TotalUnits
	lnTotalUnits = Round(TotalUnits.TotalUnits/3, 0)
	Use in TotalUnits
	For i = 1 to lnTotalUnits
		SimulateWork()
	EndFor 

	LogResults(Program(), lnTotalUnits, Seconds() - lnTimer)
EndProc 

Procedure LogResults
	Lparameters lcProgram, lnUnits, lnSeconds

	If !Used("StepsLog")
		Use StepsLog In 0
	EndIf 	
	Append Blank in StepsLog
	Replace cProgram with lcProgram, nUnits with lnUnits, nSeconds with lnSeconds in StepsLog	
	Use in StepsLog
EndProc 

