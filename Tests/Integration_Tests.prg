* ParallelFox Integration Tests
**********************************************************************
DEFINE CLASS Integration_Tests as FxuTestCase OF FxuTestCase.prg
**********************************************************************
	#IF .f.
	*
	*  this LOCAL declaration enabled IntelliSense for
	*  the THIS object anywhere in this class
	*
	LOCAL THIS AS Integration_Tests OF Integration_Tests.PRG
	#ENDIF
	
	*  
	*  declare properties here that are used by one or
	*  more individual test methods of this class
	*
	*  for example, if you create an object to a custom
	*  THIS.Property in THIS.Setup(), estabish the property
	*  here, where it will be available (to IntelliSense)
	*  throughout:
	*
*!*		ioObjectToBeTested = .NULL.
*!*		icSetClassLib = SPACE(0)

	lDebugMode = .f.
	lMTDLL = .f.
	nWorkerCount = 1
	nIterations = 1
	lAllWorkers = .f.
	cTestHelperFile = ""
	oErrorHandler = .f.

	* the icTestPrefix property in the base FxuTestCase class defaults
	* to "TEST" (not case sensitive). There is a setting on the interface
	* tab of the options form (accessible via right-clicking on the
	* main FoxUnit form and choosing the options item) labeld as
	* "Load and run only tests with the specified icTestPrefix value in test classes"
	*
	* If this is checked, then only tests in any test class that start with the
	* prefix specified with the icTestPrefix property value will be loaded
	* into FoxUnit and run. You can override this prefix on a per-class basis.
	*
	* This makes it possible to create ancillary methods in your test classes
	* that can be shared amongst other test methods without being run as
	* tests themselves. Additionally, this means you can quickly and easily 
	* disable a test by modifying it and changing it's test prefix from
	* that specified by the icTestPrefix property
	
	* Additionally, you could set this in the INIT() method of your derived class
	* but make sure you dodefault() first. When the option to run only
	* tests with the icTestPrefix specified is checked in the options form,
	* the test classes are actually all instantiated individually to pull
	* the icTestPrefix value.

*!*		icTestPrefix = "<Your preferred prefix here>"
	
	********************************************************************
	FUNCTION Setup
	********************************************************************
	*
	*  put common setup code here -- this method is called
	*  whenever THIS.Run() (inherited method) to run each
	*  of the custom test methods you add, specific test
	*  methods that are not inherited from FoxUnit
	*
	*  do NOT call THIS.Assert..() methods here -- this is
	*  NOT a test method
	*
    *  for example, you can instantiate all the object(s)
    *  you will be testing by the custom test methods of 
    *  this class:
*!*		THIS.icSetClassLib = SET("CLASSLIB")
*!*		SET CLASSLIB TO MyApplicationClassLib.VCX ADDITIVE
*!*		THIS.ioObjectToBeTested = CREATEOBJECT("MyNewClassImWriting")
		Local lcProgram
		This.lDebugMode = .f.
		This.lMTDLL = .f.
		This.nWorkerCount = 1
		This.nIterations = 1
		This.lAllWorkers = .f.
		lcProgram = Sys(16)
		This.cTestHelperFile = Addbs(JustPath(Substr(lcProgram, At(" ", lcProgram, 2) + 1))) + "TestHelper.prg"
		This.oErrorHandler = NewObject("TestErrorHandler", This.cTestHelperFile)
		This.oErrorHandler.oFxuTest = This
	********************************************************************
	ENDFUNC
	********************************************************************
	
	********************************************************************
	FUNCTION TearDown
	********************************************************************
	*
	*  put common cleanup code here -- this method is called
	*  whenever THIS.Run() (inherited method) to run each
	*  of the custom test methods you add, specific test
	*  methods that are not inherited from FoxUnit
	*
	*  do NOT call THIS.Assert..() methods here -- this is
	*  NOT a test method
	*
    *  for example, you can release  all the object(s)
    *  you will be testing by the custom test methods of 
    *  this class:
*!*	    THIS.ioObjectToBeTested = .NULL.
*!*		LOCAL lcSetClassLib
*!*		lcSetClassLib = THIS.icSetClassLib
*!*		SET CLASSLIB TO &lcSetClassLib        
		Local Parallel as Parallel
		Parallel = NewObject("Parallel", "ParallelFox.vcx")	
		Parallel.StopWorkers(.t.)
		
		This.oErrorHandler.oFxuTest = .f.
		This.oErrorHandler = .f.

	********************************************************************
	ENDFUNC
	********************************************************************	

	*
	*  test methods can use any method name not already used by
	*  the parent FXUTestCase class
	*    MODIFY COMMAND FXUTestCase
	*  DO NOT override any test methods except for the abstract 
	*  test methods Setup() and TearDown(), as described above
	*
	*  the three important inherited methods that you call
	*  from your test methods are:
	*    THIS.AssertTrue(<Expression>, "Failure message")
	*    THIS.AssertEquals(<ExpectedValue>, <Expression>, "Failure message")
	*    THIS.AssertNotNull(<Expression>, "Failure message")
	*  all test methods either pass or fail -- the assertions
	*  either succeed or fail
    
	*
	*  here's a simple AssertNotNull example test method
	*
*!*		*********************************************************************
*!*		FUNCTION TestObjectWasCreated
*!*		*********************************************************************
*!*		THIS.AssertNotNull(THIS.ioObjectToBeTested, ;
*!*			"Object was not instantiated during Setup()")
*!*		*********************************************************************
*!*		ENDFUNC
*!*		*********************************************************************

	*
	*  here's one for AssertTrue
	*
*!*		*********************************************************************
*!*		FUNCTION TestObjectCustomMethod 
*!*		*********************************************************************
*!*		THIS.AssertTrue(THIS.ioObjectToBeTested.CustomMethod()), ;
			"Object.CustomMethod() failed")
*!*		*********************************************************************
*!*		ENDFUNC
*!*		*********************************************************************

	*
	*  and one for AssertEquals
	*
*!*		*********************************************************************
*!*		FUNCTION TestObjectCustomMethod100ReturnValue 
*!*		*********************************************************************
*!*
*!*		* Please note that string Comparisons with AssertEquals are
*!*		* case sensitive. 
*!*
*!*		THIS.AssertEquals("John Smith", ;
*!*			            THIS.ioObjectToBeTested.Object.CustomMethod100(), ;
*!*			            "Object.CustomMethod100() did not return 'John Smith'",
*!*		*********************************************************************
*!*		ENDFUNC
*!*		*********************************************************************


	* DoCmd Tests
	Function DoCmd_Runs
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.DoCmd([? "FoxPro Rocks"], This.lAllWorkers)
		EndFor

		Parallel.StopWorkers()	
		Parallel.Wait()
	EndFunc 

	Function DoCmd_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.DoCmd_Runs()
	EndFunc 

	Function DoCmd_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.DoCmd_Runs()
	EndFunc 

	Function DoCmd_AllWorkers_Runs
		This.nWorkerCount = 4
		This.lAllWorkers = .t.
		Return This.DoCmd_Runs()
	EndFunc 

	Function DoCmd_AllWorkers_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.DoCmd_AllWorkers_Runs()
	EndFunc 

	Function DoCmd_AllWorkers_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.DoCmd_AllWorkers_Runs()
	EndFunc 

	Function DoCmd_Iterations_Run
		This.nWorkerCount = 4
		This.nIterations = 40
		Return This.DoCmd_Runs()
	EndFunc 

	Function DoCmd_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.DoCmd_Iterations_Run()
	EndFunc 

	Function DoCmd_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.DoCmd_Iterations_Run()
	EndFunc 

	* Do Tests
	Function Do_Runs
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.Do("FoxProRocks",, This.lAllWorkers)
		EndFor
		
		Parallel.StopWorkers()	
		Parallel.Wait()
	EndFunc 

	Function Do_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.Do_Runs()
	EndFunc 

	Function Do_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.Do_Runs()
	EndFunc 

	Function Do_AllWorkers_Runs
		This.nWorkerCount = 4
		This.lAllWorkers = .t.
		Return This.Do_Runs()
	EndFunc 

	Function Do_AllWorkers_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.Do_AllWorkers_Runs()
	EndFunc 

	Function Do_AllWorkers_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.Do_AllWorkers_Runs()
	EndFunc 

	Function Do_Iterations_Run
		This.nWorkerCount = 4
		This.nIterations = 40
		Return This.Do_Runs()
	EndFunc 

	Function Do_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.Do_Iterations_Run()
	EndFunc 

	Function Do_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.Do_Iterations_Run()
	EndFunc 

	* Call Tests
	Function Call_Runs
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.Call("FoxProRocks", This.lAllWorkers)
		EndFor
		
		Parallel.StopWorkers()	
		Parallel.Wait()
	EndFunc 

	Function Call_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.Call_Runs()
	EndFunc 

	Function Call_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.Call_Runs()
	EndFunc 

	Function Call_AllWorkers_Runs
		This.nWorkerCount = 4
		This.lAllWorkers = .t.
		Return This.Call_Runs()
	EndFunc 

	Function Call_AllWorkers_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.Call_AllWorkers_Runs()
	EndFunc 

	Function Call_AllWorkers_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.Call_AllWorkers_Runs()
	EndFunc 

	Function Call_Iterations_Run
		This.nWorkerCount = 4
		This.nIterations = 40
		Return This.Call_Runs()
	EndFunc 

	Function Call_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.Call_Iterations_Run()
	EndFunc 

	Function Call_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.Call_Iterations_Run()
	EndFunc 

	* CallMethod Tests
	Function CallMethod_Runs
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.CallMethod("FoxProRocks", "TestHelper", This.cTestHelperFile,,This.lAllWorkers)
		EndFor
		
		Parallel.StopWorkers()	
		Parallel.Wait()
	EndFunc 

	Function CallMethod_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.CallMethod_Runs()
	EndFunc 

	Function CallMethod_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.CallMethod_Runs()
	EndFunc 

	Function CallMethod_AllWorkers_Runs
		This.nWorkerCount = 4
		This.lAllWorkers = .t.
		Return This.CallMethod_Runs()
	EndFunc 

	Function CallMethod_AllWorkers_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.CallMethod_AllWorkers_Runs()
	EndFunc 

	Function CallMethod_AllWorkers_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.CallMethod_AllWorkers_Runs()
	EndFunc 

	Function CallMethod_Iterations_Run
		This.nWorkerCount = 4
		This.nIterations = 40
		Return This.CallMethod_Runs()
	EndFunc 

	Function CallMethod_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.CallMethod_Iterations_Run()
	EndFunc 

	Function CallMethod_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.CallMethod_Iterations_Run()
	EndFunc 

	* ExecScript Tests
	Function ExecScript_Runs
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Text to lcScript NoShow
			Local lcMessage
			lcMessage = "FoxPro Rocks!"
			? lcMessage
			Return lcMessage		
		EndText 
				
		For lnI = 1 to This.nIterations
			Parallel.ExecScript(lcScript,This.lAllWorkers)
		EndFor
		
		Parallel.StopWorkers()	
		Parallel.Wait()
	EndFunc 

	Function ExecScript_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.ExecScript_Runs()
	EndFunc 

	Function ExecScript_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.ExecScript_Runs()
	EndFunc 

	Function ExecScript_AllWorkers_Runs
		This.nWorkerCount = 4
		This.lAllWorkers = .t.
		Return This.ExecScript_Runs()
	EndFunc 

	Function ExecScript_AllWorkers_Runs_DebugMode
		This.lDebugMode = .t.
		Return This.ExecScript_AllWorkers_Runs()
	EndFunc 

	Function ExecScript_AllWorkers_Runs_MTDLL
		This.lMTDLL = .t.
		Return This.ExecScript_AllWorkers_Runs()
	EndFunc 

	Function ExecScript_Iterations_Run
		This.nWorkerCount = 4
		This.nIterations = 40
		Return This.ExecScript_Runs()
	EndFunc 

	Function ExecScript_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.ExecScript_Iterations_Run()
	EndFunc 
	
	Function ExecScript_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.ExecScript_Iterations_Run()
	EndFunc 
	
	Function Complete_Returns_Expected_Result
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("Complete", loTestEventHandler, "Complete")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Parallel.Call("FoxProRocks")
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertEquals("FoxPro Rocks!", loTestEventHandler.vResult)
	EndFunc 
	
	Function Complete_Returns_Expected_Result_DebugMode
		This.lDebugMode = .t.
		Return This.Complete_Returns_Expected_Result()
	EndFunc 

	Function Complete_Returns_Expected_Result_MTDLL
		This.lMTDLL = .t.
		Return This.Complete_Returns_Expected_Result()
	EndFunc 

	Function SimpleCommandHandler_Returns_Expected_Result
		Local Parallel as Parallel, lnI, lcScript, lcOldTag
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Use simple command instead of object for handler
		* tPar1 is return value from Complete. Set it to public property.
		lcOldTag = _Screen.Tag
		Parallel.BindEvent("Complete", "_Screen.Tag = tPar1")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Parallel.Call("FoxProRocks")
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertEquals("FoxPro Rocks!", _Screen.Tag)
		_Screen.Tag = lcOldTag
	EndFunc 

	Function SimpleCommandHandler_Returns_Expected_Result_DebugMode
		This.lDebugMode = .t.
		Return This.SimpleCommandHandler_Returns_Expected_Result()
	EndFunc 

	Function SimpleCommandHandler_Returns_Expected_Result_MTDLL
		This.lMTDLL = .t.
		Return This.SimpleCommandHandler_Returns_Expected_Result()
	EndFunc 

	Function ReturnData_Returns_Expected_Results
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("ReturnData", loTestEventHandler, "ReturnData")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Parallel.CallMethod("ReturnData", "TestHelper", This.cTestHelperFile,,,"FoxPro", "Rocks!")
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertEquals("FoxPro", loTestEventHandler.vResult)
		This.AssertEquals("Rocks!", loTestEventHandler.vResult2)
	EndFunc 

	Function ReturnData_Returns_Expected_Results_DebugMode
		This.lDebugMode = .t.
		Return This.ReturnData_Returns_Expected_Results()
	EndFunc 

	Function ReturnData_Returns_Expected_Results_MTDLL
		This.lMTDLL = .t.
		Return This.ReturnData_Returns_Expected_Results()
	EndFunc 

	Function UpdateProgress_Returns_Expected_Results
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("UpdateProgress", loTestEventHandler, "UpdateProgress")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Parallel.CallMethod("UpdateProgress", "TestHelper", This.cTestHelperFile,,,50, "Progress")
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertEquals(50, loTestEventHandler.vResult)
		This.AssertEquals("Progress", loTestEventHandler.vResult2)
	EndFunc 

	Function UpdateProgress_Returns_Expected_Results_DebugMode
		This.lDebugMode = .t.
		Return This.UpdateProgress_Returns_Expected_Results()
	EndFunc 

	Function UpdateProgress_Returns_Expected_Results_MTDLL
		This.lMTDLL = .t.
		Return This.UpdateProgress_Returns_Expected_Results()
	EndFunc 

	Function ReturnCursor_Returns_Cursor
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("ReturnCursor", loTestEventHandler, "ReturnCursor")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Use in Select("TestCursor")
		Parallel.CallMethod("ReturnCursor", "TestHelper", This.cTestHelperFile)
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertTrue(Used("TestCursor"), "TestCursor is not open.")
		This.AssertEquals("TESTCURSOR", Upper(loTestEventHandler.vResult))
		Use in Select("TestCursor")
	EndFunc 

	Function ReturnCursor_Returns_Cursor_DebugMode
		This.lDebugMode = .t.
		Return This.ReturnCursor_Returns_Cursor()
	EndFunc 

	Function ReturnCursor_Returns_Cursor_MTDLL
		This.lMTDLL = .t.
		Return This.ReturnCursor_Returns_Cursor()
	EndFunc 

	Function CreateTempTable_Returns_Cursor
		Local Parallel as Parallel, lnI, lcScript, lcTempTable
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("ReturnCursor", loTestEventHandler, "ReturnCursor")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		Use in Select("TempTable")
		Create Cursor TempTable (Test C(20))
		Insert Into TempTable (Test) VALUES ("FoxPro Rocks!") 
		lcTempTable = Parallel.CreateTempTable("TempTable")
		Use in Select("TempTable")
		Parallel.CallMethod("OpenTempTable", "TestHelper", This.cTestHelperFile,,,lcTempTable)
		Parallel.StopWorkers()
		Parallel.Wait()
		Parallel.DeleteTempTable(lcTempTable)

		This.AssertTrue(Used("TestCursor"), "TestCursor is not open.")
		This.AssertEquals("TESTCURSOR", Upper(loTestEventHandler.vResult))
		This.AssertEquals("FoxPro Rocks!", Rtrim(TestCursor.Test))
		This.AssertFalse(File(Addbs(Sys(2023)) + lcTempTable + ".DBF"), "TempTable.DBF still exists.")
		This.AssertFalse(File(Addbs(Sys(2023)) + lcTempTable + ".DBC"), "TempTable.DBC still exists.")
		Use in Select("TestCursor")
	EndFunc

	Function CreateTempTable_Returns_Cursor_DebugMode
		This.lDebugMode = .t.
		Return This.CreateTempTable_Returns_Cursor()
	EndFunc 

	Function CreateTempTable_Returns_Cursor_MTDLL
		This.lMTDLL = .t.
		Return This.CreateTempTable_Returns_Cursor()
	EndFunc 

	Function Error_Returns_Error
		Local Parallel as Parallel, lnI, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("ReturnError", loTestEventHandler, "ReturnError")

		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		* Cause error
		If This.lDebugMode
			* Default error handler doesn't usually run in debug mode, so set it up
			Parallel.DoCmd([_Screen.NewObject("oErrorHandler", "ErrorHandler", "ParallelFox.vcx")])
		EndIf 
		Parallel.DoCmd("Error 1")
		Parallel.StopWorkers()
		Parallel.Wait()
		
		* 1429 = OLE error
		This.AssertEquals(1429, loTestEventHandler.vResult)
		This.AssertEquals("OLE IDispatch exception code 0 from Visual FoxPro for Windows: 1 :File does not exist...", loTestEventHandler.vResult2)
	EndFunc 
	
	Function Error_Returns_Error_DebugMode
		This.lDebugMode = .t.
		Return This.Error_Returns_Error()
	EndFunc 

	Function Error_Returns_Error_MTDLL
		This.lMTDLL = .t.
		Return This.Error_Returns_Error()
	EndFunc 

	Function Load_Test_Many_Iterations_Run
		This.nWorkerCount = 8
		This.nIterations = 1000
		Return This.DoCmd_Runs()
	EndFunc

	Function Load_Test_Many_Iterations_Run_DebugMode
		This.lDebugMode = .t.
		Return This.Load_Test_Many_Iterations_Run()
	EndFunc 

	Function Load_Test_Many_Iterations_Run_MTDLL
		This.lMTDLL = .t.
		Return This.Load_Test_Many_Iterations_Run()
	EndFunc 

	Function Load_Test_Many_Workers_Run
		This.nWorkerCount = 50
		This.nIterations = 1000
		Return This.DoCmd_Runs()
	EndFunc

	Function Load_Test_Many_Workers_Run_DebugMode
		This.lDebugMode = .t.
		Return This.Load_Test_Many_Workers_Run()
	EndFunc 

	Function Load_Test_Many_Workers_Run_MTDLL
		This.lMTDLL = .t.
		Return This.Load_Test_Many_Workers_Run()
	EndFunc 

	* Multiple Instance Tests
	Function MultiInstance_DoCmd_Runs
		This.nWorkerCount = 8
		This.nIterations = 200
		* Start First instance with Debug Mode
		* Debug mode has to be first instance in test. 
		*	COM gets confused instantiating VFP when non-debug workers are already running.
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(.f.)
		* Short pause to let previous instances of VFP close, or may get error
		Inkey(1, "H")
		Parallel.StartWorkers(This.cTestHelperFile,,.t.)

		* Start Second instance with MTDLL workers
		Local Parallel2 as Parallel, lnI
		Parallel2 = NewObject("Parallel", "ParallelFox.vcx")
		Parallel2.SetInstance("MTDLL")		
		Parallel2.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel2.SetWorkerCount(This.nWorkerCount)
		Parallel2.SetMultiThreaded(.t.)
		Parallel2.StartWorkers(This.cTestHelperFile,,.f.)
		
		* Third instance with EXE workers
		Local Parallel3 as Parallel, lnI
		Parallel3 = NewObject("Parallel", "ParallelFox.vcx")
		Parallel3.SetInstance("NonDebug")		
		Parallel3.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel3.SetWorkerCount(This.nWorkerCount)
		Parallel3.SetMultiThreaded(.f.)
		Parallel3.StartWorkers(This.cTestHelperFile,,.f.)	
					
		* Run in first instance
		For lnI = 1 to This.nIterations
			Parallel.DoCmd([? "FoxPro Rocks"], This.lAllWorkers)
		EndFor
		* Run in second instance
		For lnI = 1 to This.nIterations
			Parallel2.DoCmd([? "FoxPro Rocks"], This.lAllWorkers)
		EndFor
		* Run in third instance
		For lnI = 1 to This.nIterations
			Parallel3.DoCmd([? "FoxPro Rocks"], This.lAllWorkers)
		EndFor
		
		* Stop/wait both instances
		Parallel.StopWorkers()	
		Parallel2.StopWorkers()	
		Parallel3.StopWorkers()	
		Parallel.Wait()
		Parallel2.Wait()
		Parallel3.Wait()
	EndFunc 
	
	Function Cancellation_Prevents_Completion
		Local Parallel as Parallel, lnIterations, lcScript
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("UpdateProgress", loTestEventHandler, "UpdateProgress")

		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
		
		lnIterations = 30
		Parallel.CallMethod("Cancellation", "TestHelper", This.cTestHelperFile,,,lnIterations)
		* Wait a few seconds then cancel
		Inkey(5, "H")
		Parallel.Cancel()
		Parallel.StopWorkers()
		Parallel.Wait()
		
		This.AssertFalse(loTestEventHandler.vResult = lnIterations)
		This.AssertEquals("Cancelled", loTestEventHandler.vResult2)
	EndFunc 
	
	Function Cancellation_Prevents_Completion_DebugMode
		This.lDebugMode = .t.
		Return This.Cancellation_Prevents_Completion()
	EndFunc 

	Function Cancellation_Prevents_Completion_MTDLL
		This.lMTDLL = .t.
		Return This.Cancellation_Prevents_Completion()
	EndFunc 	

	Function Worker_Version_Matches_Main_Process	
		* Worker version should match main process for VFP 9.0, Advanced 32-bit, Advanced 64-bit	 
		Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		* Bind event to handler
		Local loTestEventHandler as TestEventHandler of Tests\TestHelper.prg
		loTestEventHandler = NewObject("TestEventHandler", This.cTestHelperFile)
		Parallel.BindEvent("Complete", loTestEventHandler, "Complete")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.Call("Version", This.lAllWorkers, 4)
		EndFor
		
		Parallel.StopWorkers()	
		Parallel.Wait()
		
		This.AssertEquals(Version(4), loTestEventHandler.vResult)
	EndFunc 	

	Function Worker_Version_Matches_Main_Process_DebugMode
		This.lDebugMode = .t.
		Return This.Worker_Version_Matches_Main_Process()
	EndFunc 
	
	Function Worker_Version_Matches_Main_Process_MTDLL
		This.lMTDLL = .t.
		Return This.Worker_Version_Matches_Main_Process()
	EndFunc 

	Function Reg_Free_COM_DoCmd_Runs
				Local Parallel as Parallel, lnI
		Parallel = NewObject("Parallel", "ParallelFox.vcx")
		
		Parallel.BindEvent("ReturnError", This.oErrorHandler, "HandleError")
		Parallel.SetWorkerCount(This.nWorkerCount)
		Parallel.SetMultiThreaded(This.lMTDLL)
		Parallel.SetRegFreeCOM(.t.)
		If This.lDebugMode
			* Short pause to let previous instances of VFP close, or may get error
			Inkey(1, "H")
		EndIf 
		Parallel.StartWorkers(This.cTestHelperFile,,This.lDebugMode)
				
		For lnI = 1 to This.nIterations
			Parallel.DoCmd([? "FoxPro Rocks"], This.lAllWorkers)
		EndFor

		* Wait window 
		Parallel.StopWorkers()	
		Parallel.Wait()
		Parallel.SetRegFreeCOM(.f.) && make sure doesn't affect other tests
	EndFunc 

**********************************************************************
ENDDEFINE
**********************************************************************
