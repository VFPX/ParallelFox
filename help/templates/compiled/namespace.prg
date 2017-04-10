LOCAL CRLF
CRLF = CHR(13) + CHR(10)
_out = []

 lcSeeAlsoTopics = oHelp.InsertSeeAlsoTopics() 

Response.Write(TRANSFORM( EVALUATE([ ExecuteTemplate("Header_template.wcs") ]) ))

Response.Write([]+ CRLF +;
   []+ CRLF +;
   [<div class="contentpane">]+ CRLF +;
   [<br>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Body) ]) ))

Response.Write([]+ CRLF +;
   [<br>]+ CRLF +;
   [<br>]+ CRLF +;
   [])

 IF !EMPTY(oHelp.oTopic.Remarks) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Remarks</h3>]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Remarks) ]) ))


 ENDIF 

 IF !EMPTY(oHelp.oTopic.Example) 
Response.Write([]+ CRLF +;
   [<h3 class="Outdent">Example</h3>]+ CRLF +;
   [<pre>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Example)]) ))

Response.Write([</pre>])

 ENDIF 


lcHtml = ChildTopicsTableHtml(oHelp,"CLASSHEADER,INTERFACE,ENUM,DELEGATE","Type","Body") 
lcHtml = STRTRAN(lcHtml,"Class ","")
lcHtml = StrTran(lcHtml,"Interface ","")
lcHTML = StrTran(lcHtml,"Enumeration ","")
lcHtml = StrTran(lcHtml,"Delegate ","")
Response.Write(lcHtml)


 if !EMPTY(oHelp.oTopic.SeeAlso) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">See also</h3>])

Response.Write(TRANSFORM( EVALUATE([ lcSeeAlsoTopics ]) ))


  endif 
Response.Write([]+ CRLF +;
   [<p>]+ CRLF +;
   [</div>])

Response.Write(TRANSFORM( EVALUATE([ ExecuteTemplate("Footer_Template.wcs") ]) ))

