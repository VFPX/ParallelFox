<%@ Page language="c#"  %>
<%@import namespace="System.IO"%>
<%@import namespace="System.Text"%>
<%@import namespace="System.Text.RegularExpressions"%>

<script runat="server" language="C#">
		protected string PageTitle = "Search Page";
		protected string ResultHtml = "";
		protected int MatchCount = 0;

		private void Page_Load(object sender, System.EventArgs e)
		{	
			string Title = Request.QueryString["Title"];
			if (Title != null && Title != "")
				this.PageTitle = Title;
				
			if (this.IsPostBack && Request.Form["btnSearch"] == null) 
				this.btnSearch_Click(Page,EventArgs.Empty);
		}				
		private void btnSearch_Click(object sender, System.EventArgs e)
		{
			string Path = Request.PhysicalPath;
			Path = new FileInfo(Path).DirectoryName;
			string Search = this.txtSearch.Text;
			
			if (Search == "") 
			{
				this.ResultHtml = "Please enter a search expression.";
				return;
			}

			// Put user code to initialize the page here
			string[] FileList = Directory.GetFiles(Path,"_*.htm");
			
			StringBuilder sb = new StringBuilder();

			foreach(string Filename in FileList) 
			{
				FileInfo fi = new FileInfo(Filename);
				string Title = "";
				string Image;
				if ( SearchFile(Filename,Search,out Title,out Image) )	
				{
					sb.Append("<img src='bmp/" + Image + "'> <a href='" + fi.Name + "'>" + Title + "</a><br>");
					this.MatchCount++;
				}
			}

			if (this.MatchCount == 0)
				this.ResultHtml = "No matching topics found.";
			else 
			{
				this.ResultHtml = "<small>&nbsp;&nbsp;&nbsp;" + MatchCount.ToString() + " topics found<p>";
				this.ResultHtml += sb.ToString();
		
			}			
		}

		bool SearchFile(string File, string Search,out string Title,out string Image) 
		{
			Title = "";
			Image = "topic.gif";
			Search = Search.ToLower();

			StreamReader sr = new StreamReader(File);
			string Content = sr.ReadToEnd();
			sr.Close();

			if (Content.ToLower().IndexOf(Search) > -1) 
			{
				Title = ExtractString(Content,"<title>","</title>",false);
				Image = ExtractString(Content,"<topictype value=\"","\"",false);

				if (Image == null || Image == "" || Image.Length > 25)
					Image = "topic.gif";
				else
					Image += ".gif";
				return true;
			}
			System.Threading.Thread.Sleep(0);  // && Force to give up time slice

			return false;
		}

		protected static string ExtractString(string Source, string BeginDelim, string EndDelim, bool CaseSensitive) 
		{
			int At1, At2;

			
			if (CaseSensitive) 
			{
				At1 = Source.IndexOf(BeginDelim);
				At2 = Source.IndexOf(EndDelim,At1+ BeginDelim.Length );
			}
			else 
			{
				string Lower = Source.ToLower();
				At1 =Lower.IndexOf( BeginDelim.ToLower() );
				At2 = Lower.IndexOf( EndDelim.ToLower(),At1+ BeginDelim.Length);
			}
			  
			if (At1 > -1 && At2 > 1) 
			{
				return Source.Substring(At1 + BeginDelim.Length,At2-At1 - BeginDelim.Length);
			}

			return "";
		}
</script>
<HTML>
	<HEAD>
		<title>
			<%= this.PageTitle %>
		</title>
		<base target="wwhelp_right">
		<LINK rel="stylesheet" type="text/css" href="templates/wwhelp.css">
		<style> 
		INPUT { FONT-SIZE: 8pt } 
		</style>
	</HEAD>
	<body topmargin="0" leftmargin="0" style="BACKGROUND:white">
		<form id="SearchForm" method="post" runat="server" target="wwhelp_left">
		<table class="tocbody" width="800">
			<tr>
				<td class="banner" HEIGHT="25" VALIGN="middle">&nbsp;<b style="font-size:10pt"><%= this.PageTitle %></b>
					<div style="font-size:8pt;margin-top:5pt;margin-bottom:3pt">&nbsp;<a href="index2.htm" target="wwhelp_left">Contents</a> | <a href="Keywords.htm" target="wwhelp_left">Keywords</a></div>
				</td>
			</tr>
		</table>
			<div style="MARGIN-LEFT:5px;width:800px;padding-top:10px;" class="tocbody">
				Search for:
				<asp:TextBox id="txtSearch" runat="server" Width="136px"></asp:TextBox>
				<asp:Button id="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"></asp:Button><BR>
				<hr>
				<%= this.ResultHtml %>
			</div>
		</form>
	</body>
</HTML>
