* Makes sure examples all run
**********************************************************************
DEFINE CLASS Example_Tests as FxuTestCase OF FxuTestCase.prg
**********************************************************************
	#IF .f.
	*
	*  this LOCAL declaration enabled IntelliSense for
	*  the THIS object anywhere in this class
	*
	LOCAL THIS AS Example_Tests OF Example_Tests.PRG
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

	Function AutoYield_True_Runs

		Do Examples\AutoYield with .T.

	EndFunc 

	Function AutoYield_False_Runs

		Do Examples\AutoYield with .F.

	EndFunc 

	Function Steps_Before_Runs

		Do Examples\Steps_Before with .T.

	EndFunc 

	Function Steps_After_Runs

		Do Examples\Steps_After with .T.

	EndFunc 
	

	Function Call_Before_Runs

		Do Examples\Call_Before

	EndFunc 


	Function Call_After_Runs

		Do Examples\Call_After

	EndFunc 

	Function CallMethod_Before_Runs

		Do Examples\CallMethod_Before

	EndFunc 

	Function CallMethod_After_Runs

		Do Examples\CallMethod_After

	EndFunc 
	
	Function Complete_Before_Runs

		Do Examples\Complete_Before

	EndFunc 

	Function Complete_After_Runs

		Do Examples\Complete_After

	EndFunc 

	Function Custom_Callback_Runs

		Do Examples\Custom_Callback

	EndFunc 

	Function DoCmdScript_Before_Runs

		Do Examples\DoCmdScript_Before

	EndFunc 

	Function DoCmdScript_After_Runs

		Do Examples\DoCmdScript_After

	EndFunc 

	Function LocalVars_True_Runs

		Do Examples\LocalVars with .T.

	EndFunc 

	Function LocalVars_False_Runs

		Do Examples\LocalVars with .F.

	EndFunc 
	
	Function LongEvent_Runs

		Do Examples\LongEvent with .T.

	EndFunc 

	Function ProgressEvent_Runs

		Do Examples\ProgressEvent with .T.

	EndFunc 
	
	Function ProgressForm_Runs

		Do Examples\ProgressForm with .T.

	EndFunc 

	Function ReturnCursor_Before_Runs

		Do Examples\ReturnCursor_Before with .T.

	EndFunc 

	Function ReturnCursor_After_Runs

		Do Examples\ReturnCursor_After with .T.

	EndFunc 

	Function ReturnData_Before_Runs

		Do Examples\ReturnData_Before with .T.

	EndFunc 

	Function ReturnData_After_Runs

		Do Examples\ReturnData_After with .T.

	EndFunc 

**********************************************************************
ENDDEFINE
**********************************************************************
