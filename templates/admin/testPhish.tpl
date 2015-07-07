<p class="pagehead">
	Test Send a Phish
</p>

<p class="subhead">
	<# PROC_OUT.err #>
</p>

<div class="entry">
<form action="testPhish" method="post" enctype="multipart/form-data">
	<ul>
		<li class="entry">Send To: <input id="toAddr" type="text" name="toAddr" value="<# toAddr #>"/></li>
		<li class="entry">Email File: <input type="file" id="email" name="email" /></li>
		<li class="entry">Server: <input type="text" name="srvnport" 
			value="<# IF srvnport #><# srvnport #><# ELSE #>localhost:25<# ENDIF #>"/></li>
		<li class="entry"><input type="submit" value="Send Test"/></li>
	</ul>
</form>
</div>

