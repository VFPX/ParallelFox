* Install/register ParallelFox on developer machine

* Registering ParallelFox.exe requires elevation on Windows Vista/7
* ParallelFox /regserver without elevation will fail, but will not notify user of failure.
* This program requests elevation and confirms registration.
ShellExec(FullPath("ParallelFox.exe"),"RunAs","/regserver")
Wait "Registering ParallelFox..." window timeout .5	&& wait for registration to complete
If IsRegistered("ParallelFox.WorkerMgr")
	MessageBox("ParallelFox was registered successfully.", 64, "ParallelFox")
Else
	MessageBox("ParallelFox was NOT registered.", 16, "ParallelFox")
EndIf 

Return 

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