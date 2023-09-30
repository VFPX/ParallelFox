* Install/register ParallelFox on developer machine

* Registering ParallelFox.exe requires elevation on Windows Vista/7
* ParallelFox /regserver without elevation will fail, but will not notify user of failure.
* This program requests elevation and confirms registration.
Local llSuccess, lcMessage
ShellExec(FullPath("ParallelFox.exe"),"RunAs","/unregserver")
ShellExec("RegSvr32.exe","RunAs", "/s /u " + FullPath("MTDLL/ParallelFoxMT.dll") )
Wait "Unregistering ParallelFox..." window timeout 1	&& wait for registration to complete
lcMessage = ""
llSuccess = .t.
If !IsRegistered("ParallelFox.Application")
	lcMessage = "ParallelFox.exe was unregistered successfully."
Else
	llSuccess = .f.
	lcMessage = "ParallelFox.exe was NOT unregistered."
EndIf 
If !IsRegistered("ParallelFoxMT.Application")
	lcMessage = lcMessage + Chr(13) + "ParallelFoxMT.dll was unregistered successfully."
Else
	llSuccess = .f.
	lcMessage = lcMessage + Chr(13) + "ParallelFoxMT.dll was NOT unregistered."
EndIf 
MessageBox(lcMessage, Iif(llSuccess, 64, 16), "ParallelFox")

If MessageBox("Uninstall ParallelFox IntelliSense scripts?", 4+32, "ParallelFox IntelliSense") = 6
	Do UninstallFFI
EndIf

MessageBox("Uninstall Complete.", 64, "ParallelFox")

Return 

Procedure UninstallFFI
Local lnCurrentArea

lnCurrentArea = Select()
Select 0
Use (_FoxCode) Again Alias FFIFoxCode Shared
Delete for InList(Lower(abbrev), "parallel ", "worker ", "pfhandleffi ")
Use

Select (lnCurrentArea)
EndProc 


Function ShellExec
LParameter lcLink, lcAction, lcParms

lcAction = IIf(Empty(lcAction), "Open", lcAction)
lcParms = IIf(Empty(lcParms), "", lcParms)

DECLARE INTEGER ShellExecute ;
	IN SHELL32.dll ;
	INTEGER nWinHandle, ;
	STRING cOperation, ;
	STRING cFileName, ;
	STRING cParameters, ;
	STRING cDirectory, ;
	INTEGER nShowWindow
	
DECLARE INTEGER FindWindow ;
	IN WIN32API ;
	STRING cNull,STRING cWinName
	
Return ShellExecute(FindWindow(0, _Screen.caption), lcAction, ;
	lcLink, lcParms, JustPath(lcLink), 1)
EndFunc 

Function IsRegistered
Lparameters lcLookUpKey

* Registry roots
#DEFINE HKEY_CLASSES_ROOT           -2147483648  && BITSET(0,31)
#DEFINE HKEY_CURRENT_USER           -2147483647  && BITSET(0,31)+1
#DEFINE HKEY_LOCAL_MACHINE          -2147483646  && BITSET(0,31)+2
#DEFINE HKEY_USERS                  -2147483645  && BITSET(0,31)+3

* Load DLLs
Clear Dlls RegOpenKey
Clear Dlls RegCloseKey
LOCAL nHKey,cSubKey,nResult
DECLARE Integer RegOpenKey IN Win32API ;
	Integer nHKey, String @cSubKey, Integer @nResult
DECLARE Integer RegCloseKey IN Win32API ;
	Integer nHKey

* Try to open key
Local lnErrorCode, lnSubKey
lnSubKey = 0
lnErrorCode = RegOpenKey(HKEY_CLASSES_ROOT,lcLookUpKey,@lnSubKey)
If lnErrorCode = 0	&& success
	* Close key
	=RegCloseKey(lnSubKey)
	Return .t.
Else
	Return .f.
EndIf 
EndFunc 