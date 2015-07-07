<table><tr><td>
<p class="pagehead">
	Admin - Realtime Anti-Phishing Trainer Online Resource
</p>

<p>
    There are three main entities to know for using Raptor: Clients, Phishes, and Campaigns.
</p>
<p class="subhead">Clients</p>
<p>
    In the database, clients are just an id and a name. Only one client is required to launch campaigns.
</p>
<p class="subhead">Phishes</p>
<p>
    A Phish has two main elements: an email and a response page.
<ul>
	<li class="link">Email</li>
	<li class="flink">Raptor does search and replacement for the following tags in the email file:
		<ul>
			<li>*NAME* - replaced by the name supplied in the uploaded list of emails for a
			        campaign. More on that later.</li>
			<li>*EMAIL* - replaced by the email address to which the phish will be sent.</li>
			<li>*DATE* - replaced by a UTC timestamp.</li>
			<li>*HASH* - this tag is the uri of the phishing link, but can also be used anywhere
			       else in the phishing email. When the user clicks the “bad” link, they
			       should be directed to the Response Site, where the visit will be logged
			       for reporting, then the user will be redirected to an educational page.</li>
			<li>*MESSAGEID* - replaced by a unique id to make mail servers happy.</li>
		</ul>
	</li>
	<li class="flink">There is a sample in the phishes/ directory called fedex_simple.txt which started as an actual
	phishing email I found in my spam folder. This simple phish is a good template for what Raptor
	expects you to upload for the phishing email.</li>
	<li class="link">Response Page</li>
	<li class="flink">Raptor will redirect a user who clicks a phishing link to any url you choose for education.
	The url can be relative or absolute.</li>
	
	<li class="flink">It's a good idea to use the “Test Send Phish” page to verify that your phish is what it 
	should be and also that the mail server receiving the phishes responds in a desirable way. Raptor will send 
	the emails to any server on any port specified, but the most reliable function will come from sending them to 
	a well-configured mail server locally (localhost:25). The *NAME* and *HASH* tags will be left unchanged when Test Sending.</li>
</ul>
</p>
<p class="subhead">Campaigns</p>
	<p>A Campaign is a batch send of phishing emails. When launching a campaign, you'll upload a text file 
	with the format: [email address],[Name of Recipient] on each line. There can be as many addressees as 
	you wish. For each email successfully sent, an entry is registered in the database containing an MD5 sum 
	of the email address (in case of compromise, the list of emails will not be retrievable), the response hash, 
	and of course the id of the Campaign.</p>

<p class="subhead">Email Response History</p>
	<p>This is an easy way to look up what activity has occurred with an email address that's been included in any campaigns.</p>

<p class="subhead">CSV</p>
	<p>Throughout the administrative interface, there are “csv” links. These are for downloading raw csv data 
	for the item identified in the row.</p>
<p class="subhead">&nbsp;</p>
<p>Raptor is an actively maintained project. Really!</p>
<p>Any questions, requests, issues... please post them to sourceforge.net at the Raptor page.</p>
</td></tr></table>

