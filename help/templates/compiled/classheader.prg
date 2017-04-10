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

 if (!EMPTY(oHelp.oTopic.Inh_Tree) ) 
Response.Write([]+ CRLF +;
   [<small>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.InsertInheritanceTree() ]) ))

Response.Write([]+ CRLF +;
   [</small>])

 endif 

 IF !EMPTY(oHelp.oTopic.Syntax) 
Response.Write([]+ CRLF +;
   [<pre class="syntaxbox">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHtml( oHelp.oTopic.Syntax ) ]) ))

Response.Write([]+ CRLF +;
   [</pre>])

 ENDIF 

 IF !EMPTY(oHelp.oTopic.Remarks) 
Response.Write([]+ CRLF +;
   []+ CRLF +;
   [<h3 class="outdent">Remarks</h3>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Remarks)]) ))


 ENDIF 

 IF !EMPTY(oHelp.oTopic.Example) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Example</h3>]+ CRLF +;
   [<pre>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Example)]) ))

Response.Write([</pre>])

 ENDIF 
Response.Write([]+ CRLF +;
   []+ CRLF +;
   [<h3 class="outdentmargin">Class Members</h3>])

Response.Write(TRANSFORM( EVALUATE([ ClassMemberTableHtml(oHelp,.t.,"width='95%'") ]) ))

Response.Write([]+ CRLF +;
   []+ CRLF +;
   [<h3 class="outdent">Requirements</h3>]+ CRLF +;
   [])

 IF !EMPTY(oHelp.oTopic.Namespace) 
Response.Write([]+ CRLF +;
   [<b>Namespace:</b> ])

Response.Write(TRANSFORM( EVALUATE([ oHelp.oTopic.Namespace ]) ))

Response.Write([<br>]+ CRLF +;
   [])

 endif 

 IF !EMPTY(oHelp.oTopic.Assembly) 
Response.Write([]+ CRLF +;
   [<b>Assembly:</b> ])

Response.Write(TRANSFORM( EVALUATE([ oHelp.oTopic.Assembly ]) ))

Response.Write([]+ CRLF +;
   [<br>]+ CRLF +;
   [])

 endif 

 if !EMPTY(oHelp.oTopic.SeeAlso) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">See also:</h3>])

Response.Write(TRANSFORM( EVALUATE([ lcSeeAlsoTopics ]) ))


  endif 
Response.Write([]+ CRLF +;
   []+ CRLF +;
   [</div>]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ ExecuteTemplate("Footer_Template.wcs") ]) ))

