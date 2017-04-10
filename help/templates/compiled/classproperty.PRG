LOCAL CRLF
CRLF = CHR(13) + CHR(10)
_out = []

 lcSeeAlsoTopics = oHelp.InsertSeeAlsoTopics() 

Response.Write(TRANSFORM( EVALUATE([ ExecuteTemplate("Header_template.wcs") ]) ))

Response.Write([]+ CRLF +;
   []+ CRLF +;
   [<div class="contentpane">]+ CRLF +;
   []+ CRLF +;
   [<div class="contentbody">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Body) ]) ))

Response.Write([]+ CRLF +;
   [</div>]+ CRLF +;
   [])

 if !EMPTY(oHelp.oTopic.Syntax) 
Response.Write([]+ CRLF +;
   [<pre class="syntaxbox">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHtml(oHelp.oTopic.Syntax) ]) ))

Response.Write([]+ CRLF +;
   [</pre>])

 endif 

 IF !EMPTY(oHelp.oTopic.Parameters) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Default Value</h3>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(strtran(oHelp.oTopic.Parameters,"b>","i>"))]) ))


 ENDIF 

 IF !EMPTY(oHelp.oTopic.Exceptions) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Exceptions</h3>])

Response.Write(TRANSFORM( EVALUATE([ strtran( InsertExceptions(oHelp),"b>","i>") ]) ))


 ENDIF 

 IF !EMPTY(oHelp.oTopic.Remarks) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Remarks</h3>]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Remarks) ]) ))


 ENDIF 

 IF !EMPTY(oHelp.oTopic.Example) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Example</h3>]+ CRLF +;
   [<pre>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Example)]) ))

Response.Write([</pre>])

 ENDIF 

 IF !EMPTY(oHelp.oTopic.SeeAlso) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">See also:</h3>])

Response.Write(TRANSFORM( EVALUATE([ lcSeeAlsoTopics ]) ))


 ENDIF 
Response.Write([]+ CRLF +;
   [<p>]+ CRLF +;
   [</div>]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ ExecuteTemplate("Footer_Template.wcs") ]) ))

