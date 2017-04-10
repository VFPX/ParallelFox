LOCAL CRLF
CRLF = CHR(13) + CHR(10)
_out = []
Response.Write([<hr />]+ CRLF +;
   [<small>&nbsp;&nbsp;Last Updated: ])

Response.Write(TRANSFORM( EVALUATE([ TTOD(oHelp.oTopic.Updated) ]) ))

Response.Write([ | ]+ CRLF +;
   [&copy ])

Response.Write(TRANSFORM( EVALUATE([ oHelp.cProjCompany ]) ))

Response.Write([, ])

Response.Write(TRANSFORM( EVALUATE([ Year(Date()) ]) ))

Response.Write([</small>]+ CRLF +;
   [<br clear="all" />]+ CRLF +;
   [<br/>]+ CRLF +;
   [</body>]+ CRLF +;
   [</html>])
