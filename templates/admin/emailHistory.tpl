<p class="pagehead">
	Email Response History <# IF PROC_OUT.addr != '' #>for <# PROC_OUT.addr #><# ENDIF #>
</p>

<# IF emails.NUM_ROWS > 0 #>
<table>
	<tr>
		<th>Campaign</th>
		<th>Launched</th>
		<th>Response</th>
		<th>From IP</th>
	</tr>
	<# LOOP emails #>
	<tr>
		<td><# nickName #></td>
		<td><# launchDate #></td>
		<# IF ipResponse != '' #>
			<td><# respDate #></td>
			<td><# ipResponse #></td>
		<# ELSE #>
			<td> - </td>
			<td> - </td>
		<# ENDIF #>
	</tr>
	<# ENDLOOP #>
</table>
<# ELSIF PROC_OUT.addr != '' #>
	<p>The email address <# PROC_OUT.addr #> has not been included in a <# clientName #> campaign.</p>
<# ENDIF #>

<# IF clients.NUM_ROWS > 0 #>
<form action="/emailHistory" method="post">
	<ul>
		<li class="entry">Client: <select name="cid">
			<# LOOP clients #><option value="<# id #>"><# name #></option>
			<# ENDLOOP #></select></li>
		<li class="entry-sp">Email address: <input type="text" name="addr" value="" /></li>
		<li class="entry"><input type="submit" value="View" /></li>
	</ul>
</form>
<# ELSE #>
	<p>You will need to add at least one client first.</p>
<# ENDIF #>

