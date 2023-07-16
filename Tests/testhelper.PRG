* ParallelFox codes used by automated tests

Procedure FoxProRocks
	Local lcMessage
	lcMessage = "FoxPro Rocks!"
	? lcMessage
	Return lcMessage
EndProc 

Define Class TestHelper as Custom

	Procedure FoxProRocks
		Local lcMessage
		lcMessage = "FoxPro Rocks!"
		? lcMessage
		Return lcMessage
	EndProc 
	
	Procedure ReturnData
		Lparameters lcData1, lcData2
		Local Worker as Worker
		Worker = NewObject("Worker", "ParallelFox.vcx") 
		? lcData1, lcData2		
		Worker.ReturnData(lcData1, lcData2)
	EndProc 
	
	Procedure UpdateProgress
		Lparameters lnProgress, lcMessage	
		Local Worker as Worker
		Worker = NewObject("Worker", "ParallelFox.vcx") 
		? Program(), lnProgress, lcMessage	
		Worker.UpdateProgress(lnProgress, lcMessage)
	EndProc
	
	Procedure ReturnCursor
		Create Cursor TestCursor (Test C(10))
		Local Worker as Worker
		Worker = NewObject("Worker", "ParallelFox.vcx") 
		Worker.ReturnCursor("TestCursor")
		Use in Select("TestCursor")
	EndProc 

	Procedure OpenTempTable
		Lparameters lcTempTable
		Local Worker as Worker
		Worker = NewObject("Worker", "ParallelFox.vcx") 
		Worker.OpenTempTable(lcTempTable, "TestCursor")
		Worker.ReturnCursor("TestCursor")
		Worker.CloseTempTable("TestCursor")
	EndProc 
	
	Procedure Cancellation
		Lparameters lnIterations
		Local lnProgress
		Local Worker as Worker
		Worker = NewObject("Worker", "ParallelFox.vcx")
		For lnProgress = 1 to lnIterations
			If Worker.IsCancelled()
				Worker.UpdateProgress(lnProgress, "Cancelled")
				Exit 
			Else
				Worker.UpdateProgress(lnProgress, "In Progress")	
				Worker.Sleep(1000)
			EndIf
		EndFor 
	EndProc 

EndDefine 

Define Class TestEventHandler as Custom

	vResult = .f.
	vResult2 = .f.
	
	Procedure Complete
		Lparameters lvResult
		? Program(), lvResult
		This.vResult = lvResult
	EndProc 

	Procedure ReturnData
		Lparameters lcData1, lcData2
		? Program(), lcData1, lcData2
		This.vResult = lcData1
		This.vResult2 = lcData2
	EndProc
	
	Procedure UpdateProgress
		Lparameters lnProgress, lcMessage	
		? Program(), lnProgress, lcMessage	
		This.vResult = lnProgress
		This.vResult2 = lcMessage
	EndProc
	
	Procedure ReturnCursor
		Lparameters lcAlias
		? Program(), lcAlias
		This.vResult = lcAlias
	EndProc
	
	Procedure ReturnError
		Lparameters lnError, lcMethod, lnLine, lcMessage, lcCode
		? Program(), lnError, lcMessage
		This.vResult = lnError
		This.vResult2 = lcMessage
	EndProc 
	
EndDefine 



Define Class TestErrorHandler as Custom

	oFxuTest = .f.

	PROCEDURE HandleError(nError, cMethod, nLine, cMessage, cCode)
		Try
			Local loException as Exception
			Local array laStackInfo[1]
			loException = CreateObject("Exception")
			loException.ErrorNo = nError
			loException.Procedure = cMethod
			loException.LineNo = nLine
			loException.Message = cMessage
			loException.LineContents = cCode
			AStackInfo(laStackInfo )
			This.oFxuTest.HandleException(loException, @laStackInfo)
			
			Local Parallel as Parallel
			Parallel = NewObject("Parallel", "ParallelFox.vcx")
			Parallel.StopWorkers(.t.)
		Catch
			Set step on
		EndTry 

	ENDPROC

EndDefine 