#INCLUDE FOXCODE.H
LPARAMETERS cCmd, oFoxCode, parm3, parm4, parm5, parm6
LOCAL oFxCdeScript,lcRetValue,lnLangOpt,lnParms
lnParms=PCOUNT()

DO CASE
CASE lnParms=0
	IF TYPE("_oIntMgr")="O"
		_oIntMgr.Show()
	ELSE
***		DO FORM foxcode
	ENDIF
	RETURN
CASE VARTYPE(oFoxCode)#"O" AND PCOUNT()<3
	RETURN
ENDCASE

lcRetValue = ""
oFxCdeScript = CREATEOBJECT("foxcodescript")
oFxCdeScript.Start(@oFoxCode)

DO CASE
CASE lnParms = 2
	lcRetValue = oFxCdeScript.&cCmd.()
CASE lnParms = 3
	lcRetValue = oFxCdeScript.&cCmd.(parm3)
CASE lnParms = 4
	lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4)
CASE lnParms = 5
	lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4, parm5)
CASE lnParms = 6
	lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4, parm5, parm6)
ENDCASE

RETURN lcRetValue

********************************************************************

DEFINE CLASS foxcodescript AS session

PROTECTED lFoxCode2Used, cSYS3054, nLangOpt, cSYS2030

cEscapeState = ""
cTalk = ""
cMessage = ""
cExcl = ""
FoxCode2 = "FoxCode2"
cScriptType = ""
oFoxCode = ""
cCmd = ""
cCmd2 = ""
cLine = ""
nWords = 0
cLastWord = ""
cCustomPEMsID = "CustomPEMs"
cCustomScriptsID = "CustomDefaultScripts"
cCustomScriptName = ""
cAlias = ""
nSaveSession = 0
nWinHdl = 0
cSaveLib = ""
cSaveUDFParms = ""
lHadError = .F.
nLastKey = 0
cScriptCmd = ""
cScriptCase = ""
nSaveTally = 0
cMsgNoData = ""
lHideScriptErrors = .F.
lKeywordCapitalization = .T.
lPropertyValueEditors = .T.
lExpandCOperators = .T.
lAllowCustomDefScripts = .F.
lFoxCodeUnavailable = .F.
lDebugScripts = .F.
cFoxTools = ""

PROCEDURE Main
	* Virtual Function
ENDPROC

PROCEDURE Start(oFoxCode,cType)
	* Main start routine which should be called first by all scripts using this class
	* It sets up core properties for use by other methods.
		
	* Check for valid oFoxCode object
	IF VARTYPE(m.oFoxCode)#"O" OR VARTYPE(m.oFoxCode.FullLine)#"C"
		RETURN ""
	ENDIF
	
	* Avoid calling if within Foxcode itself
	IF ATC("FOXCODE.",oFoxCode.FileName)#0
		RETURN ""
	ENDIF
	
	THIS.nLastKey = LASTKEY()
	THIS.oFoxCode = oFoxCode
	THIS.cCmd = UPPER(ALLTRIM(GETWORDNUM(oFoxCode.FullLine,1)))
	THIS.cCmd2 = UPPER(LEFT(LTRIM(oFoxCode.FullLine), ATC(" ", LTRIM(oFoxCode.FullLine),2)))
	THIS.cLine = STRTRAN(ALLTRIM(oFoxCode.FullLine),"  "," ")
	THIS.nWords = GETWORDCOUNT(THIS.cLine)
	THIS.cLastWord = GETWORDNUM(THIS.cLine,THIS.nWords)
	THIS.cScriptType = IIF(VARTYPE(cType)="C",cType,ALLTRIM(oFoxCode.Type))
	IF ((THIS.cScriptType="C" AND ATC("L", _VFP.EditorOptions)=0) OR;
	   (THIS.cScriptType="F" AND ATC("Q", _VFP.EditorOptions)=0)) AND;
	   _VFP.StartMode=0
		THIS.oFoxcode.ValueType = "V"
		RETURN THIS.AdjustCase(ALLTRIM(THIS.oFoxcode.Expanded),THIS.oFoxcode.Case)
	ENDIF
	THIS.CheckFoxCode()
	THIS.GetCustomPEMs()
	THIS.FindFoxTools()
	IF THIS.lDebugScripts
		SYS(2030,1)
	ENDIF
	RETURN THIS.Main()
ENDPROC

PROCEDURE DefaultScript()
	* This is the main default script (Type="S" and empty Abbrev field) that gets called 
	* when spacebar pressed and can occur anywhere within line.
	LOCAL leRetVal
	IF ATC(" ",THIS.oFoxCode.FullLine)=0
		RETURN ""
	ENDIF

	* Handle custom script handlers
	leRetVal = THIS.HandleCustomScripts()
	IF VARTYPE(leRetVal)#"L" OR leRetVal
		RETURN leRetVal
	ENDIF
	
	* Special script handler for C++ type operators (++,--,+=,-=,*=,/=)
	IF THIS.HandleCOps()
		RETURN ""
	ENDIF
	
	* Core script handler
	DO CASE
	CASE THIS.HandleMRU()
		* Handle MRUs
	CASE THIS.nWords > 1
		* Returns tool tip for multi word commands or update keywords of commands
		THIS.GetCmdTip(THIS.cLine)
	ENDCASE
	
	RETURN ""
ENDPROC

PROCEDURE HandleMRU()
	* Special Handler for command supporting Most Recently Used files, classes
	* List of MRUs:
	*   USE, OPEN DATABASE, MODIFY DATABASE
	*   MODIFY VIEW, MODIFY CONNECTION, MODIFY QUERY
	*   MODIFY MEMO, MODIFY GENERAL, REPLACE
	*   MODIFY FILE, MODIFY COMMAND, DO
	*   MODIFY CLASS, MODIFY FORM, DO FORM
	*   MODIFY REPORT, MODIFY LABEL, REPORT FORM, LABEL FORM
	*   MODIFY PROJECT,  MODIFY MENU

	LOCAL lHasAlias,leCase
	LOCAL lnMRUOffset  &&used to handle Quick Info tip in Command Window
	lnMRUOffset = IIF(THIS.oFoxCode.Location#0,0,1)

	DO CASE
	CASE !INLIST(LEFT(THIS.cCmd,4),"USE","OPEN","MODI","REPO","LABE","REPL","DO")
		* Skip if not valid MRU command
		RETURN .F.
	CASE THIS.cCmd=="USE"
		* Handle USE MRU with dropdown list
		IF THIS.nWords>1 OR lnMRUOffset=0
			IF INLIST(UPPER(GETWORDNUM(THIS.ofoxcode.fullline,THIS.nWords)),"CONNSTRING","IN","ALIAS") OR;
			  THIS.nWords=1
				* For certain USE keywords that require add'l string display tip		
				IF THIS.nWords=1 AND lnMRUOffset=0
					* Handle USE case expansion in PRG
					LOCATE FOR UPPER(ALLTRIM(abbrev))=="USE" AND TYPE="C"
					IF FOUND()
						leCase = IIF(EMPTY(ALLTRIM(case)),THIS.oFoxCode.DefaultCase,Case)
						IF UPPER(leCase)#"X"
							THIS.ReplaceWord(THIS.AdjustCase(ALLTRIM(expanded),case))
						ENDIF
					ENDIF
				ENDIF
				THIS.GetCmdTip("USETIP")
			ELSE
				* Display list of keywords
				LOCATE FOR UPPER(ALLTRIM(abbrev))=="USE" AND TYPE="C"
				leCase = IIF(FOUND(),Case,.F.)
				THIS.GetItemList(THIS.cCmd,.F.,"","",leCase)
			ENDIF
		ENDIF
	CASE THIS.cCmd=="DO"
		* Handle DO,DO Form MRU
		DO CASE
		CASE THIS.nWords = lnMRUOffset
		CASE ALLTRIM(CHRTRAN(THIS.cCmd2,CHR(9),"")) == "DO WHILE"
				THIS.GetCmdTip("DO WHILE")
		CASE ALLTRIM(CHRTRAN(THIS.cCmd2,CHR(9),"")) == "DO CASE"
				THIS.GetCmdTip("DO CASE")
		CASE ALLTRIM(CHRTRAN(THIS.cCmd2,CHR(9),"")) == "DO FORM"
			IF THIS.nWords > 2 OR lnMRUOffset=0
				THIS.GetCmdTip("DO FORM")
			ENDIF
		OTHERWISE
			IF THIS.nWords=1 AND lnMRUOffset=0
				* Handle DO case expansion in PRG
				LOCATE FOR UPPER(ALLTRIM(abbrev))=="DO" AND TYPE="C"
				IF FOUND()
					leCase = IIF(EMPTY(ALLTRIM(case)),THIS.oFoxCode.DefaultCase,Case)
					IF UPPER(leCase)#"X"
						THIS.ReplaceWord(THIS.AdjustCase(ALLTRIM(expanded),case))
					ENDIF
				ENDIF
			ENDIF
			THIS.GetCmdTip("DOTIP")
		ENDCASE
	CASE INLIST(THIS.cCmd+ " ","REPL ","REPLA ","REPLAC ","REPLACE ")
		* Handle REPLACE field list
		SET DATASESSION TO 1
		THIS.cAlias = ALIAS()
		SET DATASESSION TO (THIS.nSaveSession)
		IF THIS.ofoxcode.Location=0 AND !EMPTY(THIS.cAlias) AND THIS.nWords=1
			RETURN
		ENDIF
		IF THIS.nWords=1 AND ATC("REPLACE",THIS.oFoxCode.FullLine)=0
			RETURN
		ENDIF
		THIS.GetCmdTip("REPLTIP")		
	CASE ATC("OPEN DATA",THIS.cCmd2)#0
		* Handle two word MRU with dropdown list (e.g. OPEN DATABASE)
		DO CASE
		CASE THIS.nWords=2 AND lnMRUOffset=0
			THIS.GetCmdTip("OPENDATATIP")
		CASE THIS.nWords > (1+lnMRUOffset)
			THIS.cCmd = "OPDB"
			LOCATE FOR UPPER(ALLTRIM(abbrev))=="OPEN" AND TYPE="C"
			leCase = IIF(FOUND(),Case,.F.)
			THIS.GetItemList(THIS.cCmd,.F.,"","",leCase)		
		ENDCASE
	CASE INLIST(LEFT(THIS.cCmd,4),"MODI","REPO","LABE") AND THIS.nWords>1
		* Handle two word MRU with quick info
		DO CASE
		CASE THIS.nWords < 3 AND lnMRUOffset=1
			RETURN
		CASE INLIST(THIS.cCmd+ " ","MODI ","MODIF ","MODIFY ")
			THIS.cCmd = "MODIFY "+GETWORDNUM(THIS.cCmd2,2)
		CASE INLIST(THIS.cCmd+ " ","REPO ","REPOR ","REPORT ")
			THIS.cCmd = "REPORT FORM"
		CASE INLIST(THIS.cCmd+ " ","LABE ","LABEL ")
			THIS.cCmd = "LABEL FORM"
		OTHERWISE
			RETURN .F.
		ENDCASE
		THIS.GetCmdTip(THIS.cCmd)
	OTHERWISE
		RETURN .F.
	ENDCASE
ENDPROC

PROCEDURE HandleCOps()
	* Special script handler for C++ type operators (++,--,+=,-=,*=,/=)
	LOCAL lnWordCount,lcNewWord,lclastWord,laOps,i,lnPos
	LOCAL lcVarName,lcPrefix,lcOpWord,lcSuffix
	lnWordCount=GETWORDCOUNT(THIS.cLine)
	IF VARTYPE(THIS.lExpandCOperators)#"L" OR !THIS.lExpandCOperators OR lnWordCount>2
		RETURN .F.
	ENDIF
	lclastWord = GETWORDNUM(THIS.cLine,lnWordCount)
	lcNewWord = ""
	DIMENSION laOps[8]
	laOps[1] = "++"
	laOps[2] = "--"
	laOps[3] = "+="
	laOps[4] = "-="
	laOps[5] = "*="
	laOps[6] = "/="
	laOps[7] = "^="
	laOps[8] = "%="
	FOR i = 1 TO ALEN(laOps)
		lnPos = ATC(laOps[m.i],lclastWord)
		IF lnPos > 0
			lcVarName = LEFT(lclastWord,lnPos-1)
			IF EMPTY(lcVarName) AND lnWordCount>1
				lcPrefix = GETWORDNUM(THIS.cLine,lnWordCount-1)
			ELSE
				lcPrefix = lcVarName
			ENDIF
			lcOpWord = SUBSTR(lclastWord,lnPos,2)
			lcSuffix = SUBSTR(lclastWord,lnPos+2)
			EXIT
		ENDIF
	ENDFOR
	DO CASE
	CASE lnPos=0 OR (!EMPTY(lcVarName) AND lnWordCount=2)		&& nothing to do		
	CASE (EMPTY(lcVarName) AND lnWordCount=1) OR (!ISALPHA(lcVarName) AND !EMPTY(lcVarName))	&& bad entry, skip it
	CASE INLIST(lcOpWord,"++","--") AND !EMPTY(lcSuffix)			&& skip if anything after ++, --
	CASE INLIST(RIGHT(lcVarName,1),"'","(","[")		&& nothing	
	OTHERWISE
		DO CASE
		CASE INLIST(lcOpWord,"++","--")
			lcSuffix = " " + LEFT(lcOpWord,1) + " 1"
		OTHERWISE
			lcSuffix = " " + LEFT(lcOpWord,1) + IIF(EMPTY(lcSuffix),""," ") + lcSuffix
		ENDCASE
		lcPrefix = CHRTRAN(lcPrefix,"?","")
		lcVarName = lcVarName + IIF(EMPTY(lcVarName),""," ")
		lcNewWord = lcVarName + "= " + lcPrefix + lcSuffix
		THIS.ReplaceWord(lcNewWord)
		RETURN
	ENDCASE
	RETURN .F.
ENDPROC

PROCEDURE GetCmdTip(cCmd,cType)
	* Default CMD Tip handler -- displays a quick info tip for commands
	* Used by functions for parm tips
	* Used by default script handler
	* Skip for left and right arrows
	IF INLIST(THIS.nlastkey,4,19)
		RETURN
	ENDIF
	
	* Initialize stuff
	LOCAL aTmpItems, lSuccess, lcNewCmd, lcTip, lclastWord
	LOCAL lcScript, lnLastRec, lcWord, lcCase, i
	DIMENSION aTmpItems[1]
	IF THIS.lFoxCodeUnavailable 
		RETURN
	ENDIF
	lcType = IIF(VARTYPE(cType)="C" AND !EMPTY(cType), cType, "C")
	lcLastWord = GETWORDNUM(THIS.cLine,THIS.nWords)
 	IF !ALLTRIM(THIS.oFoxCode.UserTyped) == ALLTRIM(lcLastWord)
		lcLastWord = THIS.oFoxCode.UserTyped
	ENDIF

	* Locate Command
	SELECT tip, data, cmd, case FROM (_FoxCode) ;
	  WHERE UPPER(ALLTRIM(expanded)) == UPPER(ALLTRIM(m.cCmd)) AND TYPE=UPPER(lcType) ;
	  INTO ARRAY aTmpItems

	* This section is for lines with multiple words such as SET TEXTMERGE or BROWSE NOMODIFY.
	* We need to parse word by word to try and locate actual command.
	IF _TALLY=0
		lnLastRec = 0
		lcWord = ""
		FOR i = 1 TO THIS.nWords
			lcWord = lcWord + UPPER(ALLTRIM(GETWORDNUM(cCmd,m.i)))
			LOCATE FOR UPPER(ALLTRIM(expanded))==lcWord AND TYPE=UPPER(lcType)
			IF FOUND()
				lnLastRec = RECNO()
				lcWord = lcWord + " "
			ELSE

				* Check for multi words such as ZOOM WINDOW -- 2nd pass only
				IF m.i=2 AND THIS.nWords=2
					LOCATE FOR ATC(lcword, expanded)#0 AND TYPE=UPPER(lcType)
					IF FOUND()
						lnLastRec = RECNO()
						lcWord = lcWord + " "
					ENDIF
				ENDIF	
				IF lnLastRec=0 OR (m.i=2 AND THIS.nWords>2)
					lcWord = lcWord + " "
					LOOP
				ENDIF
				
				* Most commands fall thru to here for Keyword handling (e.g. BROWSE NOMODIFY)
				GO lnLastRec
				IF UPPER(lcType)#"F"	&&skip for functions
					* This function replaces typed in word with expanded keyword.
					* Notes: issue with commands containing embedded functions --
					*  there is no easy way to know if we're within a function or
					*  still part of existing command:
					*	 ex. RETURN ALLTRIM( 
					*    ex. INSERT INTO foo (f1,f2) VALUES( 
					*  Also, we would have to parse all the way to see if we were at an open
					*  parens:
					*    ex. RETURN STRTRAN(myexpr, myexpr2, 
					*  Also, since native function is internally know, user can hit Ctrl+I to
					*  trigger this tip.
					THIS.ReplaceKeyWord(lcLastWord,Tip,case)
				ENDIF
				THIS.DisplayTip(ALLTRIM(Tip))
				RETURN
			ENDIF
		ENDFOR
		THIS.oFoxcode.ValueType = "V"
		RETURN
	ENDIF

	* SELECT statement found command
	lcTip = ALLTRIM(aTmpItems[1,1])
	lcScript = ALLTRIM(aTmpItems[1,2])
	lcNewCmd = ALLTRIM(aTmpItems[1,3])
	lcCase = ALLTRIM(aTmpItems[1,4])
	
	* This handles multiple commands found (e.g.,MODIFY FILE, CLEAR CLASS)
	IF EMPTY(lcNewCmd)
		IF UPPER(lcType)#"F"	&&skip for functions
			THIS.ReplaceKeyWord(lcLastWord,lcTip,lcCase)
		ENDIF
		THIS.DisplayTip(lcTip)
		RETURN
	ENDIF

	* Handle commands which have specified Scripts such as
	*  BUILD APP, SET ANSI, ON KEY LABEL
	IF ATC("{}",lcNewCmd)=0
		lcNewCmd = CHRTRAN(lcNewCmd,"{}","")
		LOCATE FOR UPPER(lcNewCmd) == UPPER(ALLTRIM(abbrev));
			AND UPPER(TYPE) = "S"
		IF !FOUND() OR EMPTY(data)
			THIS.DisplayTip(lcTip)
			RETURN
		ENDIF
		lcScript = ALLTRIM(data)
	ENDIF
	THIS.cScriptCmd = m.cCmd
	THIS.cScriptCase = m.lcCase
	THIS.oFoxCode.Case = m.lcCase
	SET DATASESSION TO 1
	lSuccess = EXECSCRIPT(lcScript, THIS.oFoxCode)  && Execuates actual script here
	SET DATASESSION TO (THIS.nSaveSession)
	
	* Display Tip
	IF VARTYPE(lSuccess)="L" AND !lSuccess
		THIS.DisplayTip(lcTip)
	ENDIF
	RETURN
ENDPROC

PROCEDURE DisplayTip(tcValue)
	* Displays actual quick info tip
	* If Tips window is open, outputs here instead
	IF INLIST(THIS.nlastkey,4,19)
		RETURN
	ENDIF
	
	IF AT("q", _VFP.EditorOptions)#0 AND THIS.nlastkey#9 AND _VFP.StartMode=0
	   RETURN
	ENDIF
	IF TYPE("_oFoxCodeTips.edtTips") = "O"
		_oFoxCodeTips.edtTips.Value = tcValue
		THIS.oFoxCode.ValueType = "V"
	ELSE
		THIS.oFoxcode.ValueType = "T"
		THIS.oFoxcode.ValueTip = tcValue
	ENDIF
ENDPROC

PROCEDURE GetCustomPEMs
	* This routine retrieves custom properties set in _Foxcode
	LOCAL laCustPEMs, lcProperty, lcPropValue, i, lcType
	IF THIS.lFoxCodeUnavailable 
		RETURN
	ENDIF
	DIMENSION laCustPEMs[1]
	IF !THIS.GetFoxCodeArray(@laCustPEMs, THIS.cCustomPEMsID)
		RETURN
	ENDIF
	FOR i = 1 TO ALEN(laCustPEMs)
		IF EMPTY(ALLTRIM(laCustPEMs[m.i]))
			LOOP
		ENDIF
		lcProperty =  ALLTRIM(GETWORDNUM(laCustPEMs[m.i],1,"="))
		lcPropValue = ALLTRIM(SUBSTR(laCustPEMs[m.i],ATC("=",laCustPEMs[m.i])+1))
		lcType = TYPE('EVALUATE(lcPropValue)')
		DO CASE
		CASE INLIST(lcType,"N","D","L","C")
			lcPropValue = EVALUATE(lcPropValue)
		CASE lcType="U" AND TYPE('lcPropValue')="C"
			* Property is Char, but doesn't need evaluating
		OTHERWISE
			LOOP
		ENDCASE
		THIS.AddProperty(lcProperty,lcPropValue)
	ENDFOR
ENDPROC

PROCEDURE HandleCustomScripts
	* Executes custom user plug-in scripts to the default script handler
	* Note: a user custom default script must provide a single parameter
	* for ref to this object. If .F. returned, then assume that no scripts
	* were executed and continue.
	LOCAL laCustScripts, i, leScriptRetVal

	IF VARTYPE(THIS.lAllowCustomDefScripts)#"L" OR !THIS.lAllowCustomDefScripts ;
	  OR THIS.lFoxCodeUnavailable
		RETURN .F.
	ENDIF

	DIMENSION laCustScripts[1]
	IF !THIS.GetFoxCodeArray(@laCustScripts, THIS.cCustomScriptsID)
		RETURN .F.
	ENDIF
	
	* Loop thru and handle all the custom scripts
	FOR i = 1 TO ALEN(laCustScripts)
		IF !THIS.RunScript(laCustScripts[m.i], @leScriptRetVal, .T.)
			LOOP
		ENDIF
		* leScriptRetVal return codes:
		*  .F. - script not handled, loop and try another
		*  .T. - script handled, exit
		*  Other - script handled, exit
		DO CASE
		CASE VARTYPE(leScriptRetVal)="L" AND !leScriptRetVal
			* Script not handled. Let's try another.
			* Note: a script can execute here and delegate to 
			* another as long as .F. is returned.
			LOOP
		CASE VARTYPE(leScriptRetVal)="L" AND leScriptRetVal
			* Script handled properly
			RETURN
		OTHERWISE
			* Script handled properly
			RETURN leScriptRetVal
		ENDCASE	
	ENDFOR
	RETURN .F.
ENDPROC

PROCEDURE RunScript(cScript, leRetVal, lPassTHIS)
	* Generic script to  execute a script in _Foxcode.
	*   cScript - script to run (required)
	*   leRetVal - var for script return value - must be passed by ref (required)
	*   lPassTHIS - whether to pass THIS object ref option (optional). This is more
	*    efficient than passing a parameters since users can add custom properties.
	IF EMPTY(ALLTRIM(cScript)) OR THIS.lFoxCodeUnavailable
		RETURN .F.
	ENDIF
	THIS.cCustomScriptName = ALLTRIM(cScript)
	LOCAL aTmpItems
	DIMENSION aTmpItems[1]
	SELECT Data FROM (_FoxCode);
	   WHERE UPPER(ALLTRIM(Abbrev)) == UPPER(ALLTRIM(cScript)) ;
	   AND Type = "S" AND !DELETED() ;
	   INTO ARRAY aTmpItems
	IF _TALLY=0 OR EMPTY(ALLTRIM(aTmpItems))
		RETURN .F.
	ENDIF
	IF VARTYPE(lPassTHIS)="L" AND lPassTHIS
		leRetVal = EXECSCRIPT(aTmpItems, THIS)
	ELSE
		* Default assume oFoxCode parameter like normal scripts
		leRetVal = EXECSCRIPT(aTmpItems, THIS.oFoxCode)
	ENDIF
ENDPROC

PROCEDURE RunPropertyEditor(cProperty)
	IF EMPTY(ALLTRIM(cProperty))
		RETURN .F.
	ENDIF
	LOCAL aTmpItems, lcScriptData, lcRetVal 
	DIMENSION aTmpItems[1]
	SELECT Cmd,Data FROM (_FoxCode);
	   WHERE UPPER(ALLTRIM(Abbrev)) == UPPER(ALLTRIM(cProperty)) ;
	   AND Type = "E" AND !DELETED() ;
	   INTO ARRAY aTmpItems
	IF _TALLY=0 OR EMPTY(ALLTRIM(aTmpItems))
		RETURN .F.
	ENDIF
	IF ATC("{}",aTmpItems[1])#0
		lcScriptData = aTmpItems[2]
	ELSE
		lcScriptData = STREXTRACT(aTmpItems[1],"{","}")
		IF EMPTY(lcScriptData)
			RETURN .F.
		ENDIF
		DIMENSION aTmpItems[1]
		aTmpItems[1]=""
		SELECT Cmd,Data FROM (_FoxCode);
	  	 	WHERE UPPER(ALLTRIM(Abbrev)) == UPPER(ALLTRIM(lcScriptData)) ;
	  		AND Type = "S" AND !DELETED() ;
	   		INTO ARRAY aTmpItems
		IF _TALLY=0 OR EMPTY(ALLTRIM(aTmpItems))
			RETURN .F.
		ENDIF
	ENDIF
	lcScriptData = aTmpItems[2]
	lcRetVal = EXECSCRIPT(lcScriptData,cProperty)
	RETURN lcRetVal
ENDPROC

FUNCTION GetFoxCodeArray(taArray, tcScriptID)
	* Retrieves contents of _FOXCODE as an array
	LOCAL aTmpItems, lcProperty, lcPropValue, aTmpData, i, lnLines
	IF VARTYPE(tcScriptID)#"C" OR EMPTY(tcScriptID)
		RETURN .F.
	ENDIF
	DIMENSION aTmpItems[1]
	SELECT data FROM (_FoxCode) ;
	  WHERE UPPER(ALLTRIM(abbrev)) == UPPER(tcScriptID) ;
	  INTO ARRAY aTmpItems
	IF _TALLY = 0 OR EMPTY(ALLTRIM(aTmpItems))
		RETURN .F.
	ENDIF
	DIMENSION aTmpData[1]
	lnLines = ALINES(aTmpData,ALLTRIM(aTmpItems[1]))
	DIMENSION taArray[ALEN(aTmpData)]
	ACOPY(aTmpData,taArray)
	RETURN .T.
ENDFUNC

PROCEDURE GetItemList(cKey, lDontSort, cScript, cTipSource, eConvertCase)
	* Displays a List Members style dropdown of items for user to select
	LOCAL lnTally,aTmpItems,i,lcCase
	IF AT("q", _VFP.EditorOptions)#0 AND THIS.nlastkey#9 AND _VFP.StartMode=0
	   RETURN
	ENDIF
	DIMENSION aTmpItems[1]
	cKey = UPPER(LEFT(ALLTRIM(cKey),5))
	IF EMPTY(m.cTipSource)
		cTipSource = "menutip"
	ENDIF
	IF UPPER(THIS.oFoxCode.Type) # "F"
		* Handle case where we want not display items already selected such
		* as keywords for USE commands
		SELECT menuitem, &cTipSource. FROM (THIS.FoxCode2);
			WHERE UPPER(ALLTRIM(key)) == m.cKey ;
			AND ATC(" "+ALLTRIM(menuitem),THIS.cLine)=0 ;
			INTO ARRAY aTmpItems
	ELSE
		SELECT menuitem, &cTipSource. FROM (THIS.FoxCode2);
			WHERE UPPER(ALLTRIM(key)) == m.cKey ;
			INTO ARRAY aTmpItems
	ENDIF
	lnTally = _TALLY
	IF lnTally=0
		RETURN ""
	ENDIF
	THIS.oFoxcode.ValueType = "L"
	IF VARTYPE(m.cScript)="C" AND !EMPTY(m.cScript)
	  	THIS.oFoxcode.ItemScript = m.cScript
	ENDIF
	IF VARTYPE(m.lDontSort)="L" AND m.lDontSort
		THIS.oFoxcode.ItemSort = .F.
	ENDIF
	IF VARTYPE(m.eConvertCase)="L" AND m.eConvertCase OR ;
		VARTYPE(m.eConvertCase)="C"
		lcCase = m.eConvertCase
		IF VARTYPE(lcCase)#"C"
			lcCase = UPPER(THIS.oFoxCode.Case)			
		ENDIF
		IF EMPTY(ALLTRIM(lcCase)) && Use default case
			lcCase = THIS.oFoxCode.DefaultCase
		ENDIF
		IF UPPER(lcCase)="X"
			lcCase = "M"
		ENDIF
		FOR i = 1 TO ALEN(aTmpItems,1)
			aTmpItems[m.i,1] = THIS.AdjustCase(aTmpItems[m.i,1],lcCase)
		ENDFOR
	ENDIF
	DIMENSION THIS.oFoxcode.Items[lnTally ,2]
	ACOPY(aTmpItems,THIS.oFoxcode.Items)
	RETURN cKey
ENDPROC

PROCEDURE GetSysTip(cItem, cKey)
	* Special handler for SYS() functions
	LOCAL lnTally,aTmpItems,lcTip
	DIMENSION aTmpItems[1]
	SELECT syntax2,menutip FROM (THIS.FoxCode2);
		WHERE UPPER(ALLTRIM(key)) == cKey ;
		AND UPPER(ALLTRIM(key2)) == cItem ;
		INTO ARRAY aTmpItems
	lnTally = _TALLY
	IF lnTally=0
		RETURN ""
	ENDIF
	lnTally = _TALLY
	lcTip = ALLTRIM(aTmpItems[1]) + CRLF + CRLF + ALLTRIM(aTmpItems[2]) + CRLF 
	THIS.DisplayTip(lcTip)
ENDPROC

PROCEDURE AdjustCase(cItem, cCase)
	* Adjusts case of keyword expanded to that specified in the _Foxcode script.
	IF PCOUNT()=0
		cItem = ALLTRIM(THIS.oFoxcode.Expanded)
		cCase = THIS.oFoxcode.Case
	ENDIF
	* Use Version record default if empty
	IF EMPTY(ALLTRIM(m.cCase))
		cCase = THIS.oFoxCode.DefaultCase
		IF EMPTY(ALLTRIM(m.cCase))
			cCase = "M"
		ENDIF
	ENDIF
	DO CASE
	CASE UPPER(m.cCase)="U"
	 	RETURN UPPER(m.cItem)
	CASE UPPER(m.cCase)="L"
	 	RETURN LOWER(m.cItem)
	CASE UPPER(m.cCase)="P"
	 	RETURN PROPER(m.cItem)
	CASE UPPER(m.cCase)="M"
	 	RETURN m.cItem
	CASE UPPER(m.cCase)="X"
	 	RETURN ""
	OTHERWISE
	 	RETURN ""
	ENDCASE
ENDPROC

PROCEDURE ReplaceKeyWord(cReplWord,cReplTip,cReplCase)
	* Routine used by the default script handler to find and replace command keywords.
	LOCAL lcLastWord

	* Skip for no expansion settings
	IF UPPER(cReplCase)="X"
		RETURN .F.
	ENDIF
	IF EMPTY(ALLTRIM(cReplCase))
		cReplCase = THIS.oFoxCode.DefaultCase
		IF UPPER(cReplCase)="X"
			RETURN .F.
		ENDIF
		IF EMPTY(ALLTRIM(cReplCase))
			cReplCase = "M"
		ENDIF
	ENDIF

	* Skip if comma (not supported -> REPLACE fieldname1 ADDITIVE, fieldname2...)
	IF THIS.nlastkey = 44 
		RETURN .F.
	ENDIF
	
	* Skip if custom property set
	IF VARTYPE(THIS.lKeywordCapitalization)#"L" OR !THIS.lKeywordCapitalization
		RETURN .F.
	ENDIF

	lcLastWord = THIS.GetKeyWord(cReplWord,cReplTip)

	IF EMPTY(lcLastWord)
		RETURN .F.
	ENDIF
	lcLastWord = THIS.AdjustCase(lcLastWord,cReplCase)

	* Skip for first word
	IF UPPER(lcLastWord)==UPPER(GETWORDNUM(cReplTip,1)) AND !UPPER(lcLastWord)=="SELECT"
		RETURN ""
	ENDIF

	RETURN THIS.ReplaceWord(lcLastWord,.T.)
ENDPROC

PROCEDURE GetKeyWord(cLastWord,cTip)
	* This routine searches tip for keyword match of lcLastWord
	* delimeters include - space, tab, comma, |, [, ]

	LOCAL lcPrevWord,lnWords,i,lcNextWord,lnPos
	lcPrevWord = UPPER(ALLTRIM(GETWORDNUM(THIS.cLine,THIS.nWords-1)))
	lnWords = GETWORDCOUNT(cTip)

	* Check if we're in quotes
	IF THIS.IsInQuotes() && skip if within quotes
		RETURN ""
	ENDIF

	* Some special case for SQL Select since it has special internal parser
	IF UPPER(THIS.cCmd)=="SELECT"
		* Skip for "FROM" clause
		IF UPPER(lcPrevWord)=="FROM"
			RETURN ""
		ENDIF
		IF THIS.nWords=2 AND !INLIST(UPPER(cLastWord)+" ","ALL ","TOP ","DIST ")
			RETURN ""
		ENDIF
	ENDIF

	* Handle common operators
	IF INLIST(UPPER(cLastWord)+" ","AND ","OR ","NOT ")
		RETURN cLastWord
	ENDIF
	
	* Check for keyword followed by lists and expressions
	*  ex. BROWSE [FIELDS FieldList]
	*  ex. SUM ... [TO MemVarList | TO ARRAY ArrayName]
	IF AT(lcPrevWord+" "+UPPER(cLastWord),cTip)=0 AND THIS.nWords>2
		* Valid case to skip (e.g., TO ARRAY arrayname) - must be exact uppercase match	
		FOR i = 1 TO (lnWords-1)
			IF INLIST(GETWORDNUM(cTip,m.i)+" ", "["+lcPrevWord+" ", "|"+lcPrevWord+" ", lcPrevWord+" ")
				lcNextWord = GETWORDNUM(cTip,m.i+1)
				DO CASE
				CASE LEFT(lcNextWord,1)="[" AND RIGHT(lcNextWord,1)="]" 
					IF ATC(cLastWord,STREXTRACT(lcNextWord,"[","]"))#0
						EXIT
					ENDIF
					IF lnWords>m.i+1
						lcNextWord = GETWORDNUM(cTip,m.i+2)
					ENDIF
				CASE lcNextWord = "|" AND lnWords>m.i+1
					lcNextWord = GETWORDNUM(cTip,m.i+2)
					IF UPPER(lcNextWord)=lcNextWord AND lnWords>m.i+2
						lcNextWord = GETWORDNUM(cTip,m.i+3)
					ENDIF
				ENDCASE
				IF (ISALPHA(lcNextWord) OR ISALPHA(CHRTRAN(lcNextWord,"[",""))) AND UPPER(lcNextWord)#lcNextWord
					RETURN ""
				ENDIF
			ENDIF
		ENDFOR
	ENDIF

	* Special case Handle for SCOPE clause
	IF ATC("[Scope]",cTip)#0 AND  INLIST(UPPER(cLastWord)+" ","ALL ","REST ","NEXT ","RECO ","RECOR ","RECORD ")
		IF ATC(cLastWord,"RECORD")#0
			cLastWord = "RECORD"
		ENDIF
		RETURN cLastWord
	ENDIF

	DIMENSION aKeyWords[1]
	ALINES(aKeyWords,cTip,"[","|"," ","]")

	* Search for exact match
	IF ASCAN(aKeyWords,UPPER(cLastWord),-1,-1,-1,6) > 0
		RETURN cLastWord
	ENDIF
	* Search for close match expansion, skip for < 4 chars
	IF LEN(cLastWord) < 4
		RETURN ""
	ENDIF
	lnPos = ASCAN(aKeyWords,UPPER(cLastWord),-1,-1,-1,4)
	IF lnPos > 0
		RETURN aKeyWords[lnPos]
	ENDIF
	RETURN ""
ENDPROC

PROCEDURE ReplaceWord(cNewWord,lComplexParse)
	* Generic routine that uses Editor API routines to replace the last word with specified one.
	* Has special parameter to handle special parsing for VFP commands based on Quick Info
	* tip syntax.
	LOCAL lnretcode,env,lcNewWord,lcChar
	LOCAL lnEndPos,lnStartPos,lcLastWord,lnDiff,lcSaveLib,lnStartPos2
	* lComplexParse - used mainly be default script for Complex VFP syntax parsing
	*  of command keywords.
	lcNewWord = cNewWord
	IF INLIST(THIS.nLastKey,19,4)
		RETURN .F.
	ENDIF
	IF !FILE(THIS.cFoxTools)
		RETURN .F.
	ENDIF
	SET LIBRARY TO (THIS.cFoxTools) ADDITIVE
	THIS.nWinHdl = _wontop()
	IF THIS.nWinHdl = 0
		RETURN .F.
	ENDIF

	* Check environment of window
	* Check for selection, empty file or read-only file
	DIMENSION env[25]
	lnretcode = _EdGetEnv(THIS.nWinHdl,@env)
	IF lnretcode#1 OR (EMPTY(env[EEfilename]) AND env[EElength]=0) OR;
		env[STSEL]#env[ENDSEL] OR env[EElength]=0 OR env[EEreadOnly]#0
		THIS.nWinHdl = 0
		RETURN .F.
	ENDIF

	* Get end position of last word
	lnEndPos = env[STSEL]-1
	DO WHILE .T.
		lcChar = _EDGETCHAR(THIS.nWinHdl,lnEndPos)
		IF TYPE("lcChar")#"C" OR lnEndPos<=0
			* something failed
			RETURN .F.
		ENDIF
		IF !(lcChar$ENDCHARS)
			EXIT
		ENDIF 
		lnEndPos = lnEndPos - 1
	ENDDO

	* Get start position of last word
	lnStartPos = lnEndPos
	DO WHILE .T.
		lcChar = _EDGETCHAR(THIS.nWinHdl,lnStartPos)
		IF VARTYPE(lcChar)#"C"
			* something failed
			RETURN .F.
		ENDIF

		* Look for character that indicates a new word
		*  ENDCHARS - CHR(13),CHR(9),CHR(32)
		IF !lComplexParse
			IF lcChar$ENDCHARS
				EXIT
			ENDIF
		ELSE
			* Quick check for valid replacement word
			IF GETWORDCOUNT(cNewWord)>1
				RETURN .F.
			ENDIF
			* Special handling for default script
			*  ex. make sure we are not in a function with a space after "( "
			IF lcChar$ENDCHARS
				lnStartPos2 = lnStartPos
				DO WHILE lcChar$ENDCHARS
					lcChar = _EDGETCHAR(THIS.nWinHdl,lnStartPos2)
					IF VARTYPE(lcChar)#"C" OR lnStartPos2<1
						EXIT
					ENDIF
				    lnStartPos2 = lnStartPos2-1
				ENDDO
				IF !ISALPHA(lcChar) AND !INLIST(lcChar,"'",'"',"]",")",";",".") AND !ISDIGIT(lcChar)
					IF lcChar=="*" AND UPPER(lcNewWord)=="FROM"
						EXIT
					ELSE
						RETURN .F.
					ENDIF			
				ENDIF
				EXIT
			ENDIF
			IF !ISALPHA(lcChar) AND !ISDIGIT(lcChar)
				DO CASE
				CASE UPPER(THIS.cCmd)=="SELECT" AND UPPER(lcNewWord)=="SELECT" AND lcChar="("
					EXIT
				CASE !INLIST(lcChar,"'",'"',"]",")")				
					RETURN .F.
				ENDCASE
			ENDIF
		ENDIF
		lnStartPos = lnStartPos - 1
	ENDDO

	* Perform actual text replacement here
	lnStartPos = lnStartPos + 1
	lcLastWord=_EDGETSTR(THIS.nWinHdl,lnStartPos,lnEndPos)
	IF !lcLastWord == lcNewWord
		lnDiff = env[STSEL] - lnEndPos - 1
		_EDSELECT(THIS.nWinHdl,lnStartPos,lnEndPos+1)
		_EDDELETE(THIS.nWinHdl)
		_EDINSERT(THIS.nWinHdl,lcNewWord ,LEN(lcNewWord ))
		_EDSETPOS(THIS.nWinHdl,_EDGETPOS(THIS.nWinHdl) + lnDiff)
	ENDIF
	THIS.nWinHdl = 0
ENDPROC

FUNCTION IsInQuotes
	* Functions returns whether current editor position is at a location within open quote so
	* that it will be part of a string when close quote is added.
	LOCAL i, lcChar, lInQuote, lcQuoteChar
	FOR i = 1 TO LEN(THIS.cLine)
		lcChar = SUBSTR(THIS.cLine,m.i,1)
		IF !lInQuote
			IF INLIST(lcChar,'"',"'","[")
				lInQuote = .T.
				lcQuoteChar = lcChar
			ENDIF
		ELSE
			IF (lcQuoteChar="[" AND lcChar="]") OR (lcChar==lcQuoteChar AND lcQuoteChar#"[")
				lInQuote = .F.
			ENDIF
		ENDIF
	ENDFOR
	RETURN lInQuote
ENDFUNC

PROCEDURE CheckFoxCode
	* Checks if FoxCode can be opened
	IF EMPTY(_FOXCODE) OR !FILE(_FOXCODE)
		THIS.lFoxCodeUnavailable = .T.
		RETURN
	ENDIF
	THIS.lHideScriptErrors = .T.
	SELECT 0
	USE (_FOXCODE) SHARED
	IF EMPTY(ALIAS())
		THIS.lFoxCodeUnavailable = .T.		
	ENDIF
	THIS.lHideScriptErrors = .F.
ENDPROC

PROCEDURE Init
	THIS.cTalk = SET("TALK")
	SET TALK OFF
	THIS.nLangOpt = _VFP.LanguageOptions
	IF THIS.nLangOpt#0
		_VFP.LanguageOptions=0
	ENDIF
	THIS.cMessage = SET("MESSAGE",1)
	THIS.cMsgNoData = SET("NOTIFY",2)
	SET NOTIFY CURSOR OFF
	THIS.cEscapeState = SET("ESCAPE")
	SET ESCAPE OFF
	THIS.lFoxCode2Used=USED("FoxCode2")
	THIS.cExcl=SET("EXCLUSIVE")
	SET EXCLUSIVE OFF
	THIS.cSYS3054=SYS(3054)
	SYS(3054,0)
	THIS.nSaveSession = THIS.DataSessionId
	THIS.cSaveLib = SET("LIBRARY")
	THIS.cSaveUDFParms = SET("UDFPARMS")
	SET UDFPARMS TO VALUE
	SET EXACT ON
	THIS.nSaveTally = _TALLY
	THIS.cSYS2030=SYS(2030)
ENDPROC

PROCEDURE Destroy
	IF ATC("FOXTOOLS",SET("LIBRARY"))#0 AND ATC("FOXTOOLS",THIS.cSaveLib)=0
		RELEASE LIBRARY (THIS.cFoxTools)
	ENDIF
	IF THIS.cEscapeState="ON"
		SET ESCAPE ON		
	ENDIF
	IF USED("FoxCode2") AND !THIS.lFoxCode2Used
		USE IN FoxCode2
	ENDIF
	IF THIS.cTalk="ON"
		SET TALK ON		
	ENDIF
	IF THIS.cExcl="ON"
		SET EXCLUSIVE ON
	ENDIF
	SYS(3054,INT(VAL(THIS.cSYS3054)))
	IF THIS.nLangOpt#0
		_VFP.LanguageOptions=THIS.nLangOpt
	ENDIF
	IF THIS.cSaveUDFParms="REFERENCE"
		SET UDFPARMS TO REFERENCE
	ENDIF
	_TALLY=THIS.nSaveTally
	IF THIS.cMsgNoData = "ON"
		SET NOTIFY CURSOR ON
	ENDIF
	SYS(2030,INT(VAL(THIS.cSYS2030)))
ENDPROC

PROCEDURE GetInterface()
	LOCAL lcData
***	DO FORM "ints.scx" TO lcData
	RETURN lcData
ENDPROC

PROCEDURE FindFoxTools()
	* Try to locate FOXTOOLS, especiall for runtime apps.
	* User can also set it explicitly if they want.
	DO CASE
	CASE FILE(THIS.cFoxTools)
		* Skip if file is already set
	CASE FILE(SYS(2004)+"FOXTOOLS.FLL")
		THIS.cFoxTools = SYS(2004)+"FOXTOOLS.FLL"
	CASE FILE(HOME(1)+"FOXTOOLS.FLL")
		THIS.cFoxTools = HOME(1)+"FOXTOOLS.FLL"
	CASE FILE(ADDBS(JUSTPATH(_CODESENSE))+"FOXTOOLS.FLL")
		THIS.cFoxTools = ADDBS(JUSTPATH(_CODESENSE))+"FOXTOOLS.FLL"
	CASE FILE(ADDBS(JUSTPATH(_FOXCODE))+"FOXTOOLS.FLL")
		THIS.cFoxTools = ADDBS(JUSTPATH(_FOXCODE))+"FOXTOOLS.FLL"
	ENDCASE
ENDPROC

PROCEDURE Error(nError,cMethod,nLine)
	LOCAL lcErr
	THIS.lHadError = .T.
	IF THIS.lHideScriptErrors 
		RETURN
	ENDIF
	IF INLIST(nError,3)
		WAIT WINDOW FOXERR2_LOC+MESSAGE()
	ELSE
		TEXT TO lcErr TEXTMERGE NOSHOW PRETEXT 2
		A FoxCode script error has occured.
		  Error:   <<TRANS(m.nError)>>
		  Method:  <<m.cMethod>>
		  Line:    <<TRANS(m.nLine)>>
		  Message: <<MESSAGE()>>
		ENDTEXT
		STRTOFILE(m.lcErr, HOME()+"foxcode.err",.T.)
		ACTIVATE SCREEN
		? lcErr
	ENDIF
	IF THIS.lDebugScripts
		SET STEP ON
		RETRY
	ENDIF
ENDPROC

ENDDEFINE


PROCEDURE _wontop
PROCEDURE _edgetenv
PROCEDURE _edsetenv
PROCEDURE _edgetchar
PROCEDURE _edselect
PROCEDURE _edgetstr
PROCEDURE _eddelete
PROCEDURE _edinsert
PROCEDURE _edsetpos
PROCEDURE _edgetpos
