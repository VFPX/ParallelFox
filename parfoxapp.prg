* Starting with ParallelFox 2.0, this class is exposed to COM rather than WorkerMgr.
* The sole purpose of this class is to start a VFP COM environment and 
*	expose the _VFP Application object.  All other code is in ParallelFox.vcx.
* The intention is that this class/interface will never change.  Therefore, once
*	ParallelFox.exe is registered it will never need to be registered again. 
*	The rest of the code can be updated independently, and multiple version (2.0 or later)
*	can exist on a system without running into DLL Hell issues.

DEFINE CLASS Application AS Custom OLEPUBLIC

VFP = _VFP

* Hide all other properties and methods
Hidden BaseClass
Hidden Class 
Hidden ClassLibrary 
Hidden Comment 
Hidden ControlCount 
Hidden Controls 
Hidden Height 
Hidden HelpContextID 
Hidden Left 
Hidden Name 
Hidden Objects 
Hidden Parent 
Hidden ParentClass 
Hidden Picture 
Hidden Tag 
Hidden Top 
Hidden WhatsThisHelpID 
Hidden Width 
Hidden Destroy 
Hidden Error 
Hidden Init 
Hidden AddObject 
Hidden AddProperty 
Hidden NewObject 
Hidden ReadExpression 
Hidden ReadMethod 
Hidden RemoveObject 
Hidden ResetToDefault 
Hidden SaveAsClass 
Hidden ShowWhatsThis 
Hidden WriteExpression 
Hidden WriteMethod 

ENDDEFINE
