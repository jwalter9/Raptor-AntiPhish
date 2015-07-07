<p class="pagehead">
	Campaigns
</p>

<# IF clients.NUM_ROWS > 0 && phishes.NUM_ROWS > 0 #>
<form action="launchCampaign" method="post" enctype="multipart/form-data">
	<ul>
		<li class="entry">Launch New Campaign</li>
		<li class="entry">Name: <input type="text" name="nickname"/></li>
		<li class="entry">Client: <select name="clientid"><# LOOP clients #>
						<option value="<# id #>"><# name #></option><# ENDLOOP #>
					</select></li>
		<li class="entry">Phish: <select name="phishid"><# LOOP phishes #>
						<option value="<# id #>"><# nickname #></option><# ENDLOOP #>
					</select></li>
		<li class="entry">Email file: <input type="file" name="emaillist"/></li>
		<li class="entry">Server: <input type="text" name="srvnport" value="localhost:25"/></li>
		<li class="entry"><input type="submit" value="Launch"/></li>
	</ul>
</form>
<# ELSE #>
<p class="subhead">
	First add at least one phish and one client.
</p>
<# ENDIF #>

<# IF campaignCounts.NUM_ROWS > 0 #>
	<table>
		<tr>
			<th>Name</th>
			<th>Client</th>
			<th>Phish</th>
			<th>Launched</th>
			<th>Total Sent</th>
			<th>Response Rate</th>
			<th></th>
		</tr>
	<# LOOP campaignCounts #>
		<tr>
			<td><# campName #></td>
			<td><# clientname #></td>
			<td><# phishname #></td>
			<td><# launchDate #></td>
			<td><# total #></td>
			<td><# responseRate #></td>
			<td><a href="/csvData?cmid=<# id #>" target="_blank">csv</a></td>
		</tr>
	<# ENDLOOP #>
	</table>
<# ELSE #>
	<p>No campaigns have been launched yet.</p>
<# ENDIF #>

