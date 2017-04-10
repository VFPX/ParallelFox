
#DEFINE CLSID_KEY				"CLSID"
#DEFINE TYPELIB_KEY				"TYPELIB"
#DEFINE HKEY_CLASSES_ROOT		-2147483648  && BITSET(0,31)
#DEFINE MSG_ADDACTIVEX1_LOC		"Reading Registry for typelibs..."
#DEFINE MSG_ADDACTIVEX2_LOC		"Processed "
#DEFINE MSG_ADDACTIVEX3_LOC		"% complete"
#DEFINE MSG_ADDACTIVEX4_LOC		"Adding ActiveX Items to Catalog..."
#DEFINE MSG_ADDACTIVEX5_LOC		"Searching Registry for available typelibs..."
#DEFINE MSG_ADDACTIVEX6_LOC		"Preparing to read in COM Servers..."
#DEFINE MSG_ADDACTIVEX7_LOC		"Preparing to read in ActiveX Controls..."

#DEFINE PROGID_KEY				"\ProgID"
#DEFINE CONTROL_KEY				"Control"
#DEFINE SERVER_KEY				"Programmable"
#DEFINE SHELL_KEY				"\Shell\"
#DEFINE INPROC_KEY				"InProcServer32"
#DEFINE LOCALSVR_KEY			"LocalServer32"

#DEFINE CAPCASE_UPPER_LOC		"UPPERCASE"
#DEFINE CAPCASE_LOWER_LOC		"lowercase"
#DEFINE CAPCASE_PROPER_LOC		"Propercase"
#DEFINE CAPCASE_MIXED_LOC		"MixedCase"
#DEFINE CAPCASE_DEFAULT_LOC		"Use FoxCode default"
#DEFINE CAPCASE_NONE_LOC		"No auto-expansion"
#DEFINE CAPCASE_OTHER_LOC		"Leave current settings"
#DEFINE CAPCASE_VARIOUS_LOC		"various"
#DEFINE CAPCASE_DEFAULT2_LOC	"FoxCode default"

#DEFINE CLEAN_MRU_LOC			"This option removes non-existent file entries from Most Recently Used file lists. Proceed?"
#DEFINE ZAP_MRU_LOC				"This option deletes all Most Recently Used file lists. Proceed?"
#DEFINE DONE_MRU_LOC			"MRU Lists have been processed."
#DEFINE CLEAN_FOXCODE_LOC		"This option cleans up your FoxCode table. Proceed?"
#DEFINE DONE_CLEAN_LOC			"Foxcode table has been cleaned."
#DEFINE DONE_CLEAN2_LOC			"Foxcode table could not be cleaned. Check to see that the file is not already in use."
#DEFINE RESTORE_FOXCODE_LOC		"This option restores your FoxCode table to the original default one. Proceed?"
#DEFINE DONE_RESTORE_LOC		"A clean copy of the FoxCode table has been restored. The original was copied to: "
#DEFINE RESTORE_LOCATION_LOC	"Your current FoxCode table is not set to the default user HOME(7) location. Would you like to restore to this location?"

#DEFINE ERR_FCODEINUSE_LOC		"File in use error. Check to see that FOXCODE.DBF is not opened exclusively."

#DEFINE ERR_FCODE2INUSE_LOC		"File in use error. Check to see that FOXCODE.DBF or FOXREFS.DBF is not opened."
#DEFINE CLASS_EXISTS_LOC		"Class already exists in FoxCode."
#DEFINE NOREFRESH_LOC			"Failed to refresh."

#DEFINE	TYPES_TYPELIB_LOC	"Type Library"
#DEFINE	TYPES_CLASSES_LOC	"Custom Class"
#DEFINE	TYPES_TYPES_LOC		"Core"

#DEFINE	TYPE_COMMAND_LOC	"Command"
#DEFINE	TYPE_FUNCTION_LOC	"Function"
#DEFINE	TYPE_PROPERTY_LOC	"Property"
#DEFINE	TYPE_SCRIPT_LOC		"Script"
#DEFINE	TYPE_OTHER_LOC		"Other"

#DEFINE DELETEREC_LOC	"Are you sure you want to delete this item?"
#DEFINE IMPORTFILE_LOC	"Select File to Import to FoxCode"
#DEFINE IMPORTBADFILE_LOC	"Selected file cannot be imported because it does not have the same structure as FoxCode."
#DEFINE IMPORTDONE_LOC	"FoxCode has been updated with imported file."

#DEFINE LBLREPLACE1_LOC		"Re\<place"
#DEFINE LBLREPLACE2_LOC		"Na\<me"
#DEFINE LBLWITH_LOC			"Wit\<h"
#DEFINE BTNADD1_LOC			"\<Add"
#DEFINE BTNADD2_LOC			"Repl\<ace"

#DEFINE CRLF	CHR(13)+CHR(10)
#DEFINE FOXERR1_LOC "A FoxCode error has occcured. Check the FOXCODE.ERR file."
#DEFINE FOXERR2_LOC "A FoxCode error has occcured: "

#DEFINE SCRIPTNAME_LOC 	"Please enter name of script to run delimited with braces (ex. {}, {myscript})."

#DEFINE INTMGR_STATUS_LOC	"IntelliSense Manager"
#DEFINE CURRENTSET_LOC "(current setting)"

#DEFINE EEfilename      1
#DEFINE EElength		2
#DEFINE EEreadOnly		12
#DEFINE STSEL			17
#DEFINE ENDSEL			18
#DEFINE ENDCHARS		" 	"+CHR(13)+CHR(10)

#DEFINE INTELLI_AUTO_LOC		"Automatic"
#DEFINE INTELLI_MANUAL_LOC		"Manual"
#DEFINE INTELLI_DISABLE_LOC		"Disabled"

#DEFINE	RESTOREFCODE_LOC	"Your FoxCode IntelliSense table (foxcode.dbf) is missing. Without it, IntelliSense may not function. Would you like to restore it?"

#DEFINE BADCLASSFILE_LOC	"An invalid file or class was selected."

#DEFINE OLDFOXCODE_VERSION_LOC	"An outdated version of Foxcode.dbf (_FOXCODE) was found. A backup copy of this file was made in the original location and it has been replaced with a new updated version. You need to quit and restart Visual FoxPro for changes to take effect."
