<cfimport prefix="decorate" taglib="/tags/decorator/" />
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>QOTD &raquo; <decorate:title page="#target#" /></title>
		<link rel="stylesheet" href="../../css/snazzy.css" />
		<decorate:head page="#target#" />
	</head>

	<body>
		<div id="header">
			<img src="../../images/logo.png" alt="logo" />
		</div>
		<decorate:body page="#target#" />
	</body>
</html>
