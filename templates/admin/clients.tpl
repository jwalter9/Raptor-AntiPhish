<p class="pagehead">
	Clients
</p>

<script type="text/javascript">
	function editPop(id, name){
		document.getElementById('cid').value = id;
		document.getElementById('cname').value = name;
	}
	function editClear(){
		document.getElementById('cid').value = '0';
		document.getElementById('cname').value = '';
	}
</script>

<form action="editClient" method="post">
	<input type="hidden" id="cid" name="cid" value="0" />
	<ul>
		<li class="entry">Add/Edit Client</li>
		<li class="entry-sp">Name: <input type="text" id="cname" name="cname"/></li>
		<li class="entry"><input type="submit" value="Save"/> 
				  <input type="button" value="Clear" onclick="editClear();"/></li>
	</ul>
</form>

<p class="err">
	<# PROC_OUT.err #>
</p>

<# IF clientCounts.NUM_ROWS > 0 #>
	<table>
		<tr>
			<th>Name</th>
			<th>Campaigns</th>
			<th>Response Rate</th>
			<th></th>
			<th></th>
		</tr>
	<# LOOP clientCounts #>
		<tr>
			<td><# name #></td>
			<td><# numCampaigns #></td>
			<td><# responseRate #></td>
			<td><a href="/csvData?clid=<# id #>" target="_blank">csv</a></td>
			<td><a href="#" onclick="editPop(<# id #>,'<# name #>');">edit</a></td>
		</tr>
	<# ENDLOOP #>
	</table>
<# ELSE #>
	<p>No clients have been added yet.</p>
<# ENDIF #>

