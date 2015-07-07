<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title>Raptor - <# PROC_OUT.mvp_template #></title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<style type="text/css">
	body {
		background: #FAFADE; font-size:14px; 
	}
	#links {
		 width: 300px; float: left;
	}
	li.link {
		list-style: none; padding-left: 15px; font-weight: bold;
	}
	li.spacer {
		list-style: none; width: 300px; height: 150px;
	}
	li.flink {
		list-style: none; padding-left: 15px;
	}
	li.entry {
		list-style: none; padding-bottom: 20px; padding-right: 0px;
	}
	li.entry-sp {
		list-style: none; padding-bottom: 20px; padding-right: 40px;
	}
	#container {
		 margin-left: auto; margin-right: auto; height: 600px;
	}
	<# IF mvp_template != 'login' && mvp_template != 'testPhish' #>
	#container form {
		float: right; background: #DDDD9D;
	}
	<# ENDIF #>
	#container th {
		padding-right: 40px; padding-bottom: 20px;
	}
	#container td {
		padding-right: 40px; padding-bottom: 20px;
	}
	p.pagehead {
		font-size: 24px;
	}
	p.subhead {
		font-size: 18px;
	}
	</style>
	<script type="text/javascript">
		function tologin(){
			window.location.href = '/login';
		}
		<# IF mvp_template != 'login' #>
		window.setTimeout(tologin,600000);
		<# ENDIF #>
	</script>
</head>
<body>
	<div id="links">
		<ul id="link-list">
			<li class="link"><img src="/images/RaptorAndMouse.png"/></li>
			<li class="link"><a href="/admin">How-To</a></li>
			<li class="link"><a href="/clients">Clients</a></li>
			<li class="link"><a href="/phishes">Phishes</a></li>
			<li class="link"><a href="/testPhish">Test Send Phish</a></li>
			<li class="link"><a href="/campaigns">Campaigns</a></li>
			<li class="link"><a href="/emailHistory">Email Response History</a></li>
			<li class="link"><a href="/logout">Logout</a></li>
			<li class="spacer"></li>
			<li class="flink">Powered by MVProc</li>
			<li class="flink">Provided by Lowadobe Web Services, LLC</li>
			<li class="flink"><a href="mailto:lowadobe@gmail.com">Contact</a></li>
		</ul>
	</div>
	<div id="container">
		<# TEMPLATE #>
	</div>
</body>
</html>

