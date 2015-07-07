<p class="pagehead">
	Phishes
</p>

<p class="err">
	<# err #>
</p>

<div class="entry">
<form action="editPhish" method="post" enctype="multipart/form-data">
	<ul>
		<li class="entry">Add New Phish</li>
		<li class="entry">Name: <input id="pnick" type="text" name="pnick"/></li>
		<li class="entry">Email File: <input type="file" id="email" name="email" /></li>
		<li class="entry">Response URL: <input type="text" id="presponse" name="presponse" /></li>
		<li class="entry"><input type="submit" value="Save"/></li>
	</ul>
</form>
</div>

<# IF phishCounts.NUM_ROWS > 0 #>
	<table>
		<tr>
			<th>Name</th>
			<th>Total Sent</th>
			<th>Responses</th>
			<th>Response Rate</th>
			<th></th>
		</tr>
	<# LOOP phishCounts #>
		<tr>
			<td><# phishname #></td>
			<td><# total #></td>
			<td><# responses #></td>
			<td><# responseRate #></td>
			<td><a href="/csvData?phid=<# id #>" target="_blank">csv</a></td>
		</tr>
	<# ENDLOOP #>
	</table>
<# ELSE #>
	<p>No phishes have been added yet.</p>
<# ENDIF #>
