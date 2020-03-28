var gaDiv = document.getElementById('ga_div');
var gaExists = (document.getElementById('ga_div') && document
		.getElementById('ga_div').parentNode !== undefined);

if (!gaExists) {
	function loadGoogleAnalytics(trackingId) {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.id = 'ga_div';
		ga.className = 'ga_div';
		ga.async = true;
		ga.src = 'https://www.googletagmanager.com/gtag/js?id=' + trackingId;
		document.getElementsByTagName('head')[0].appendChild(ga);
	}

	var trackingId = document.currentScript.getAttribute('data-uid');
	loadGoogleAnalytics(trackingId); // Create the script
	var newScript = document.createElement('script');
	var inlineScript = document
			.createTextNode('window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag(\'js\', new Date());gtag(\'config\', \''
					+ trackingId + '\');');
	newScript.appendChild(inlineScript);
	document.getElementsByTagName('head')[0].appendChild(newScript);
}
