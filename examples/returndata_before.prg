* ReturnData event example
Lparameters llNoBrowse	&& .T. for unit test
Local loMyObject
Clear 
loMyObject = CreateObject("MyObject")
loMyObject.lNoBrowse = llNoBrowse
loMyObject.Test()

Return 

DEFINE CLASS MyObject AS Custom

oThermometer = NULL

lNoBrowse = .f.

Procedure Test
	Local i, lnTimer, loMyObject

	lnTimer = Seconds()
	Use in Select("ReturnDataLog")
	Erase ReturnDataLog.dbf

	For i = 1 to 10
		This.RunUnits(i * 10)
	EndFor 
	This.SaveResults()
	? "Total Time", Seconds() - lnTimer
	Select ReturnDataLog
	If !This.lNoBrowse
		Browse Last NoCaption NORMAL 		
	EndIf 
	Use 
	Erase ReturnDataLog.dbf
EndProc 

Procedure RunUnits
	Lparameters lnUnits
	Local i, lnSeconds
	? Program(), lnUnits
	lnSeconds = Seconds()
	For i = 1 to lnUnits
		This.SimulateWork()
	EndFor 	
	This.LogResults(lnUnits, Seconds() - lnSeconds)
EndProc 

Procedure LogResults
	Lparameters lnUnits, lnSeconds
	If !File("ReturnDataLog.dbf")
		Create Table ReturnDataLog (nUnits I, nSeconds N(8,2))
	EndIf 
	If !Used("ReturnDataLog")
		Use ReturnDataLog in 0
	EndIf 
	Set Multilocks on
	CursorSetProp("Buffering",5, "ReturnDataLog")	&& optimistic table buffering
	Append Blank in ReturnDataLog
	Replace nUnits with lnUnits, nSeconds with lnSeconds in ReturnDataLog
EndProc 

Procedure SaveResults
	Begin Transaction 
	If TableUpdate(1, .t., "ReturnDataLog")
		End Transaction 	
	Else
		RollBack 
		MessageBox("Error: Data could not be saved.")
	EndIf 
EndProc 

Procedure SimulateWork
	Local i

	For i = 1 to 1000000
		* Peg CPU
	EndFor
EndProc 

ENDDEFINE

