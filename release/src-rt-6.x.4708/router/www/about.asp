<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<!--
	Tomato GUI
	Copyright (C) 2006-2010 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] About</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<% css(); %>
<script type='text/javascript' src='tomato.js'></script>
<style type='text/css'>
#donate a:hover,
#donate a:active {
    background-color: #ededed;
    text-decoration: none;
}
</style>
<script type='text/javascript'>
//	<% nvram(''); %>	// http_id

var clicks = 0;
var tux = null;
var t = 0;
var r = 3;
var rd = 1;

function moo()
{
	if ((r <= 2) || (r >= 25)) rd = -rd;
	r += rd;
	t += (Math.PI / 10);
	if (t > (2 * Math.PI)) t = 0;

	var x = tux.origX + (r * Math.sin(t));
	var y = tux.origY + (r * Math.cos(t));

	tux.style.left = x + 'px';
	tux.style.top = y + 'px';

	if (clicks > 0) setTimeout(moo, 33);
}

function onClick()
{
	try {
		++clicks;
		if (clicks < 10) moo();
			else clicks = 0;
	}
	catch (ex) {
	}
}

function init()
{
	try {
		tux = E('tux');

		var o = elem.getOffset(tux);
		tux.origX = o.x;
		tux.origY = o.y;

		tux.style.position = 'absolute';
		tux.style.left = o.x + 'px';
		tux.style.top = o.y + 'px';

		addEvent(tux, "click", function(e) { onClick(); });
	}
	catch (ex) {
	}
	var elements = document.getElementsByClassName("new_window");
	for (var i = 0; i < elements.length; i++) if (elements[i].nodeName.toLowerCase()==="a")
		addEvent(elements[i], "click", function(e) { cancelDefaultAction(e); window.open(this,"_blank"); } );
}
</script>
<!-- / / / -->

</head>
<body onload='init()'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<div style='float:right;margin:20px 20px;text-align:center'>
<img src='tux.png' alt='Linux &amp; Tomato' id='tux'>
</div>
<div class='about'>
<b>FreshTomato Firmware <% version(1); %></b><br />
<br />
Linux kernel <% version(2); %> and Broadcom Wireless Driver <% version(3); %><br />
<br />
<b>Forums about Tomato</b> - PL: <a href='https://openlinksys.info' class='new_window'>https://openlinksys.info</a> EN: <a href='https://www.linksysinfo.org' class='new_window'>https://linksysinfo.org</a><br />
<b>FreshTomato team: </b><a href='https://bitbucket.org/kille72/tomato-arm-kille72' class='new_window'>@kille72</a>, <a href='https://bitbucket.org/pedro311/freshtomato-arm' class='new_window'>@pedro</a><br />
<br />
<hr>
<!-- / / / -->

<br />

<b>TomatoUSB Team features:</b><br />
<!-- USB-BEGIN -->
- USB support integration and GUI<br />
<!-- USB-END -->
<!-- IPV6-BEGIN -->
- IPv6 support<br />
<!-- IPV6-END -->
- Dual-band and Wireless-N mode<br />
<i>Copyright (C) 2008-2011 Fedor Kozhevnikov, Ray Van Tassle, Wes Campaigne</i><br />
<a href='http://www.tomatousb.org/' class='new_window'>http://www.tomatousb.org</a><br />
<br />

<b>"Shibby" features:</b><br />
<!-- BBT-BEGIN -->
- Transmission integration<br />
<!-- BBT-END -->
<!-- BT-BEGIN -->
- GUI for Transmission<br />
<!-- BT-END -->
<!-- NFS-BEGIN -->
- NFS utils integration and GUI<br />
<!-- NFS-END -->
- Custom log file path<br />
<!-- LINUX26-BEGIN -->
- SD-idle tool integration for kernel 2.6<br />
<!-- USB-BEGIN -->
- 3G Modem support (big thanks for @LDevil)<br />
- 4G/LTE Modem support<br />
<!-- USB-END -->
- MutliWAN feature (written by @Arctic, modified by @Shibby)<br />
<!-- LINUX26-END -->
<!-- SNMP-BEGIN -->
- SNMP integration and GUI<br />
<!-- SNMP-END -->
<!-- UPS-BEGIN -->
- APCUPSD integration and GUI (implemented by @arrmo)<br />
<!-- UPS-END -->
<!-- DNSCRYPT-BEGIN -->
- DNScrypt-proxy integration and GUI<br />
<!-- DNSCRYPT-END -->
<!-- TOR-BEGIN -->
- TOR Project integration and GUI<br />
<!-- TOR-END -->
<!-- OPENVPN-BEGIN -->
- OpenVPN: Routing Policy<br />
<!-- OPENVPN-END -->
- TomatoAnon project integration and GUI<br />
- TomatoThemeBase project integration and GUI<br />
- Ethernet Ports State<br />
- Extended MOTD (written by @Monter, modified by @Shibby)<br />
- Webmon Backup Script<br />
<i>Copyright (C) 2011-2014 Michał Rupental</i><br />
<a href='http://openlinksys.info' class='new_window'>http://openlinksys.info</a><br />
<br />

<b>Tomato-RAF features:</b><br />
- Extended Sysinfo<br />
<!-- NOCAT-BEGIN -->
- Captive Portal (Based in NocatSplash)<br />
<!-- NOCAT-END -->
<!-- NGINX-BEGIN -->
- Web Server (NGinX)<br />
<!-- NGINX-END -->
<!-- HFS-BEGIN -->
- HFS / HFS+ filesystem integration<br />
<!-- HFS-END -->
<i>Copyright (C) 2007-2014 Ofer Chen &amp; Vicente Soriano</i><br />
<a href='http://victek.is-a-geek.com' class='new_window'>http://victek.is-a-geek.com</a><br />
<br />

<b>"Teaman" features:</b><br />
- QOS-detailed &amp; ctrate filters<br />
- Realtime bandwidth monitoring of LAN clients<br />
- Static ARP binding<br />
- VLAN administration GUI<br />
- Multiple LAN support integration and GUI<br />
- Multiple/virtual SSID support (experimental)<br />
- UDPxy integration and GUI<br />
<!-- PPTPD-BEGIN -->
- PPTP Server integration and GUI<br />
<!-- PPTPD-END -->
<i>Copyright (C) 2011 Augusto Bott</i><br />
<a href='http://code.google.com/p/tomato-sdhc-vlan/' class='new_window'>Tomato-sdhc-vlan Homepage</a><br />
<br />

<b>"Lancethepants" features:</b><br />
<!-- DNSSEC-BEGIN -->
- DNSSEC integration and GUI<br />
<!-- DNSSEC-END -->
<!-- DNSCRYPT-BEGIN -->
- DNSCrypt-Proxy selectable/manual resolver<br />
<!-- DNSCRYPT-END -->
<!-- TINC-BEGIN -->
- Tinc Daemon integration and GUI<br />
<!-- TINC-END -->
- Comcast DSCP Fix GUI<br />
<i>Copyright (C) 2014 Lance Fredrickson</i><br />
<a href='mailto:lancethepants@gmail.com'>lancethepants@gmail.com</a><br />
<br />

<b>"Toastman" features:</b><br />
- Configurable QOS class names<br />
- Comprehensive QOS rule examples set by default<br />
- GPT support for HDD by Yaniv Hamo<br />
- Tools-System refresh timer<br />
<i>Copyright (C) 2011 Toastman</i><br />
<a href='http://www.linksysinfo.org/index.php?threads/using-qos-tutorial-and-discussion.28349/' class='new_window'>Using QoS - Tutorial and discussion</a><br />
<br />

<!-- VPN-BEGIN -->
<b>"JYAvenard" features:</b><br />
<!-- OPENVPN-BEGIN -->
- OpenVPN enhancements &amp; username/password only authentication<br />
<!-- OPENVPN-END -->
<!-- PPTPD-BEGIN -->
- PPTP VPN Client integration and GUI<br />
<!-- PPTPD-END -->
<i>Copyright (C) 2010-2012 Jean-Yves Avenard</i><br />
<a href='mailto:jean-yves@avenard.org'>jean-yves@avenard.org</a><br />
<br />

<!-- OPENVPN-BEGIN -->
<b>TomatoVPN feature:</b><br />
- OpenVPN integration and GUI<br />
<i>Copyright (C) 2010 Keith Moyer</i><br />
<a href='mailto:tomatovpn@keithmoyer.com'>tomatovpn@keithmoyer.com</a><br />
<br />

<b>"TomatoEgg" feature:</b><br />
- Openvpn username/password verify feature and configure GUI.<br />
<br />
<!-- OPENVPN-END -->
<!-- VPN-END -->

<!-- NGINX-BEGIN -->
<b>Tomato-hyzoom feature:</b><br />
- MySQL Server integration and GUI<br />
<i>Copyright (C) 2014 Bao Weiquan, Hyzoom</i><br />
<a href='mailto:bwq518@gmail.com'>bwq518@gmail.com</a><br />
<br />
<!-- NGINX-END -->

<b>"Victek/PrinceAMD/Phykris/Shibby" feature:</b><br />
- Revised IP/MAC Bandwidth Limiter<br />
<br />

<b>Special thanks:</b><br />
We want to express our gratitude to all people not mentioned here but contributed with patches, new models additions, bug solving and updates to Tomato firmware.<br />
<br />

<hr>
<br /><b>FreshTomato-ARM - is an alternative, customized version, forked off from Tomato-ARM by Shibby</b>																											
<br />
Copyright (C) 2016-2018 FreshTomato team
<br />
<br />
Built on <% build_time(); %> by <a href='https://exotic.se' class='new_window'>@kille72</a>
<br />
<br />
<br />
Click below to send a "Thank you" gift through PayPal  
<br />
<br />
<div id="donate">
	<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=ZSMTVT4WQN2W2&amp;lc=GB&amp;item_name=Thank%20you%20for%20FreshTomato%2e%20Keep%20it%20up&amp;item_number=Kille72&amp;currency_code=EUR&amp;bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted" class="new_window"><img style="border:none" alt="Donate" src="donate.gif"/></a><br />
</div>
<br />
<br />
<b>Based on Tomato Firmware v1.28</b><br />
<i>Copyright (C) 2006-2010 Jonathan Zarate</i><br />
<a href='http://www.polarcloud.com/tomato/' class='new_window'>http://www.polarcloud.com/tomato/</a><br />
<br />

<!--

	Please do not remove or change the homepage link or donate button.

	Thanks.
	- Jon

-->

<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<div>
<input type="hidden" name="cmd" value="_s-xclick">
<input type="image" src="pp.gif" style="border:0" name="submit" alt="Donate">
<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----">
</div>
</form>
<br />
<br />
<b>Thanks to everyone who risked their routers, tested, reported bugs, made
suggestions and contributed to this project. ^ _ ^</b>
</div>
<!-- / / / -->

</td></tr>
	<tr><td id='footer' colspan=2>&nbsp;</td></tr>
</table>
</body>
</html>
