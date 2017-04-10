LOCAL CRLF
CRLF = CHR(13) + CHR(10)
_out = []
Response.Write([<html>]+ CRLF +;
   [<head>]+ CRLF +;
   [	<topictype value="topic"/>]+ CRLF +;
   [	<title>Welcome to West Wind Html Help Builder</title>]+ CRLF +;
   [	<base href="file:///])

Response.Write(TRANSFORM( EVALUATE([ SYS(5) + Curdir() ]) ))

Response.Write([">]+ CRLF +;
   [	<link rel="stylesheet" type="text/css" href="templates/wwhelp.css">]+ CRLF +;
   [</head>]+ CRLF +;
   [<body topmargin="0" leftmargin="0">]+ CRLF +;
   [<img src="bmp/images/newwave.jpg" align="left" ] + ;
 [style="position:absolute;left:0;top:0;">]+ CRLF +;
   [<!-- img src="bmp/images/wwToolLogo.jpg" style="position:absolute;left:0;top:0" ] + ;
 [-->]+ CRLF +;
   [<img src="bmp/images/wwHelplogo.gif" style="position:absolute;left:5;top:30">]+ CRLF +;
   []+ CRLF +;
   [<div style="position:absolute;left:195;top:35;margin-right:40px">]+ CRLF +;
   [<table width="95%"><td><tr>] + CRLF )
Response.Write([<b>Welcome to Help Builder</b>,<br>]+ CRLF +;
   [Currently there is <i>No Open Project</i> in Help Builder's IDE. Your next step ] + ;
 [is to create]+ CRLF +;
   [a new project or open an existing one.]+ CRLF +;
   [<p>]+ CRLF +;
   [<img src="bmp/images/newproject.gif" border="0" align="left"> &nbsp;<b><a ] + ;
 [href="vfps://NOOPENPROJECT/CREATEPROJECT/">Create a new Project</a></b>]+ CRLF +;
   [<br>]+ CRLF +;
   [A project consists of a directory structure that contains a project file and the] + ;
 [ base templates and images.]+ CRLF +;
   [<br>]+ CRLF +;
   [<p>]+ CRLF +;
   [<img src="bmp/project.gif" border="0" align="left"> &nbsp;<b><a ] + ;
 [href="vfps://NOOPENPROJECT/OPENPROJECT">Open an existing Project</a></b>] + CRLF )
Response.Write([<br>]+ CRLF +;
   [Open an previously created Help Builder Project. ])


PUBLIC ARRAY laRecent[1]
lnRecent = goHelp.oConfig.GetRecentList(@laRecent)
if lnRecent > 0
   lcOutput= ;
   [<small><form action="vfps://NOOPENPROJECT/OPENFILE/" method="post" style="margin-top:0;padding-top:5">] +;
   [<select name="txtProject" onchange="form.submit();" style="font-size:8pt">] +;
   [<option>---   Recent Projects   ---] + CHR(13) + CHR(10) 

   FOR __x = 1 to lnRecent    
      lcTItemText = laRecent[__x]
      IF !EMPTY(lcTItemText)
         lcOutput = lcOutput + [<option>] + lcTItemText + CHR(13) + CHR(10)
      ENDIF
   ENDFOR
   lcoutput = lcOutput + "</select></form></small>"
   Response.Write(lcOutput)
endif
RELEASE laRecent

Response.Write([]+ CRLF +;
   [<p>]+ CRLF +;
   [<img src="bmp/images/help.gif" border="0" align="left"> &nbsp;<b><a ] + ;
 [href="vfps://NOOPENPROJECT/SHOWHELP">View Help Builder Documentation</a></b>]+ CRLF +;
   [<br>]+ CRLF +;
   [Browse the Help Builder documentation and check out what features are available ] + ;
 [for application and component documentation.]+ CRLF +;
   [<p>]+ CRLF +;
   [<img src="bmp/classheader.gif" border="0" align="left"> &nbsp;<b><a ] + ;
 [href="vfps://NOOPENPROJECT/SHOWSTEPBYSTEP">Take a Step by Step Tour</a></b>]+ CRLF +;
   [<br>]+ CRLF +;
   [Take a few minutes and run through the Step By Step guides that shows you how to] + ;
 [ setup]+ CRLF +;
   [a new project, add topics, link to other topics, capture and embed images and ] + ;
 [build your] + CRLF )
Response.Write([help file.]+ CRLF +;
   [<p>]+ CRLF +;
   [<img src="bmp/weblink.gif" border="0" align="left"> &nbsp;<b><a ] + ;
 [href="http://www.west-wind.com/wwthreads/default.asp?forum=Html+Help+Builder" ] + ;
 [target="_wwSupport">Online Support</a></b>]+ CRLF +;
   [<br>]+ CRLF +;
   [Go to our online Message Board and ask a question, make a suggestion or ] + ;
 [otherwise]+ CRLF +;
   [discuss any ideas or questions you have about Help Builder. ]+ CRLF +;
   []+ CRLF +;
   [</td></tr></table>]+ CRLF +;
   [</div>]+ CRLF +;
   [</body>] + CRLF )
Response.Write([</html>])
