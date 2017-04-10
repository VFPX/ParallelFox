LOCAL CRLF
CRLF = CHR(13) + CHR(10)
_out = []
Response.Write([<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" ] + ;
 ["http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">]+ CRLF +;
   [<html xmlns="http://www.w3.org/1999/xhtml">]+ CRLF +;
   [<head> ]+ CRLF +;
   [	<topictype value="])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Type) ]) ))

Response.Write([" />]+ CRLF +;
   [	<title>])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Topic) ]) ))

Response.Write([</title>]+ CRLF +;
   [	<link rel="stylesheet" type="text/css" href="templates/wwhelp.css">])

 if !EMPTY(lcSeeAlsoTopics) 
Response.Write([]+ CRLF +;
   [	<script src="templates/wwhelp.js" type="text/javascript"></script>])

 endif 
Response.Write([]+ CRLF +;
   [</head>]+ CRLF +;
   [<body>]+ CRLF +;
   [<div class="banner">]+ CRLF +;
   [  <div>])

 if !EMPTY(lcSeeAlsoTopics) 
Response.Write([]+ CRLF +;
   [		  <img src="bmp/seealso.gif" border=0  alt="Related Topics" ] + ;
 [style="cursor:hand" onmouseover="SeeAlsoButton();" />]+ CRLF +;
   [	<div id="See" class="hotlinkbox" style="display:none" ] + ;
 [onmouseleave="SeeAlsoButton();">]+ CRLF +;
   [	  <b>See also</b><br>]+ CRLF +;
   [	  <div class="seealsotopics">])

Response.Write(TRANSFORM( EVALUATE([ STRTRAN(lcSeeAlsoTopics,"|","<br/>") ]) ))

Response.Write([</div>]+ CRLF +;
   [	</div>])

 endif 
Response.Write([]+ CRLF +;
   [	<span class="projectname">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.cProjectname ]) ))

Response.Write([</span>]+ CRLF +;
   [ </div>]+ CRLF +;
   [ <div class="topicname">]+ CRLF +;
   [	<img src="bmp/])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Type)]) ))

Response.Write([.gif">])

Response.Write(TRANSFORM( EVALUATE([ iif(oHelp.oTopic.Static,[<img src="bmp/static.gif" />] + ']' + [,[] + ']' + [) ]) ))

Response.Write([&nbsp;])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Topic) ]) ))

Response.Write([]+ CRLF +;
   [ </div>]+ CRLF +;
   [</div>])
