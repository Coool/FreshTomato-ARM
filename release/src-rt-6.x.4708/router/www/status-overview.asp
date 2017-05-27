<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<!--
	Tomato GUI
	Copyright (C) 2006-2010 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	Tomato VLAN GUI
	Copyright (C) 2011 Augusto Bott
	http://code.google.com/p/tomato-sdhc-vlan/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] Status: Overview</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<% css(); %>
<script type='text/javascript' src='tomato.js'></script>
<script type='text/javascript' src='interfaces.js'></script>

<!-- / / / -->

<style type='text/css'>
.controls {
	width: 90px;
	margin-top: 5px;
	margin-bottom: 10px;
}
</style>

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvstat(); %>
//	<% etherstates(); %>
//	<% anonupdate(); %>

wmo = {'ap':'Access Point','sta':'Wireless Client','wet':'Wireless Ethernet Bridge','wds':'WDS'};
auth = {'disabled':'-','wep':'WEP','wpa_personal':'WPA Personal (PSK)','wpa_enterprise':'WPA Enterprise','wpa2_personal':'WPA2 Personal (PSK)','wpa2_enterprise':'WPA2 Enterprise','wpaX_personal':'WPA / WPA2 Personal','wpaX_enterprise':'WPA / WPA2 Enterprise','radius':'Radius'};
enc = {'tkip':'TKIP','aes':'AES','tkip+aes':'TKIP / AES'};
bgmo = {'disabled':'-','mixed':'Auto','b-only':'B Only','g-only':'G Only','bg-mixed':'B/G Mixed','lrs':'LRS','n-only':'N Only'};

lastjiffiestotal = 0;
lastjiffiesidle = 0;
lastjiffiesusage = 100;
</script>

<script type='text/javascript' src='wireless.jsx?_http_id=<% nv(http_id); %>'></script>
<script type='text/javascript' src='status-data.jsx?_http_id=<% nv(http_id); %>'></script>

<script type='text/javascript'>
show_dhcpc = [];
show_codi = [];
for (var uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
	var u ;
	u = (uidx>1) ? uidx : '';
	proto = nvram['wan'+u+'_proto'];
	if (proto != 'disabled') show_langateway = 0;
	show_dhcpc[uidx-1] = ((proto == 'dhcp') || (proto == 'lte') || (((proto == 'l2tp') || (proto == 'pptp')) && (nvram.pptp_dhcp == '1')));
	show_codi[uidx-1] = ((proto == 'pppoe') || (proto == 'l2tp') || (proto == 'pptp') || (proto == 'ppp3g'));
}

show_radio = [];
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
/* REMOVE-BEGIN
//	show_radio.push((nvram['wl'+wl_unit(uidx)+'_radio'] == '1'));
REMOVE-END */
	if (wl_sunit(uidx)<0)
		show_radio.push((nvram['wl'+wl_fface(uidx)+'_radio'] == '1'));
}

nphy = features('11n');

function dhcpc(what, wan_prefix)
{
	form.submitHidden('dhcpc.cgi', { exec: what, prefix: wan_prefix, _redirect: 'status-overview.asp' });
}

function serv(service, sleep)
{
	form.submitHidden('service.cgi', { _service: service, _redirect: 'status-overview.asp', _sleep: sleep });
}

function wan_connect(uidx)
{
	serv('wan'+uidx+'-restart', 5);
}

function wan_disconnect(uidx)
{
	serv('wan'+uidx+'-stop', 2);
}

function wlenable(uidx, n)
{
	form.submitHidden('wlradio.cgi', { enable: '' + n, _nextpage: 'status-overview.asp', _nextwait: n ? 6 : 3, _wl_unit: wl_unit(uidx) });
}

var ref = new TomatoRefresh('status-data.jsx', '', 0, 'status_overview_refresh');

ref.refresh = function(text)
{
	stats = {};
	try {
		eval(text);
	}
	catch (ex) {
		stats = {};
	}
	show();
}


function c(id, htm)
{
	E(id).cells[1].innerHTML = htm;
}

function ethstates()
{
	port = etherstates.port0;
	if (port == "disabled") { return 0; }

	var state, state1, state2;
	var code = '<div class="section-title">Ethernet Ports State<\/div>';
	code += '<table class="fields"><tr>';
	var v = 0;
	for (uidx = 1; uidx <= nvram.mwan_num; ++uidx){
		u = (uidx>1) ? uidx : '';
		if ((nvram['wan'+u+'_sta'] == '') && (nvram['wan'+u+'_proto'] != 'lte') && (nvram['wan'+u+'_proto'] != 'ppp3g')) {
			code += '<td class="title indent2" style="text-align:center"><b>WAN'+u+'<\/b><\/td>';
			++v;
		}
	}
	for (uidx = v ; uidx <= 4; ++uidx){
		code += '<td class="title indent2" style="text-align:center"><b>LAN'+uidx+'<\/b><\/td>';
	}
	code += '<tr>';

	if (port == "DOWN") {
		state = '<img id="eth_off" src="eth_off.png"><br />';
		state2 = port.replace("DOWN","Unplugged");
	} else if ((port == "1000FD") || (port == "1000HD")) {
		state = '<img id="eth_1000" src="eth_1000.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	} else {
		state = '<img id="eth_100" src="eth_100.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	}
	if (stats.lan_desc == '1') {
		code += '<td class="title indent2" style="text-align:center">' + state + state2 + '<\/td>';
	} else {
		code += '<td class="title indent2" style="text-align:center">' + state + '<\/td>';
	}

	port = etherstates.port1;
	if (port == "DOWN") {
		state = '<img id="eth_off" src="eth_off.png"><br />';
		state2 = port.replace("DOWN","Unplugged");
	} else if ((port == "1000FD") || (port == "1000HD")) {
		state = '<img id="eth_1000" src="eth_1000.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	} else {
		state = '<img id="eth_100" src="eth_100.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	}
	if (stats.lan_desc == '1') {
		code += '<td class="title indent2" style="text-align:center">' + state + state2 + '<\/td>';
	} else {
		code += '<td class="title indent2" style="text-align:center">' + state + '<\/td>';
	}

	port = etherstates.port2;
	if (port == "DOWN") {
		state = '<img id="eth_off" src="eth_off.png"><br />';
		state2 = port.replace("DOWN","Unplugged");
	} else if ((port == "1000FD") || (port == "1000HD")) {
		state = '<img id="eth_1000" src="eth_1000.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	} else {
		state = '<img id="eth_100" src="eth_100.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	}
	if (stats.lan_desc == '1') {
		code += '<td class="title indent2" style="text-align:center">' + state + state2 + '<\/td>';
	} else {
		code += '<td class="title indent2" style="text-align:center">' + state + '<\/td>';
	}

	port = etherstates.port3;
	if (port == "DOWN") {
		state = '<img id="eth_off" src="eth_off.png"><br />';
		state2 = port.replace("DOWN","Unplugged");
	} else if ((port == "1000FD") || (port == "1000HD")) {
		state = '<img id="eth_1000" src="eth_1000.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	} else {
		state = '<img id="eth_100" src="eth_100.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	}
	if (stats.lan_desc == '1') {
		code += '<td class="title indent2" style="text-align:center">' + state + state2 + '<\/td>';
	} else {
		code += '<td class="title indent2" style="text-align:center">' + state + '<\/td>';
	}

	port = etherstates.port4;
	if (port == "DOWN") {
		state = '<img id="eth_off" src="eth_off.png"><br />';
		state2 = port.replace("DOWN","Unplugged");
	} else if ((port == "1000FD") || (port == "1000HD")) {
		state = '<img id="eth_1000" src="eth_1000.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	} else {
		state = '<img id="eth_100" src="eth_100.gif"><br />';
		state1 = port.replace("HD","M Half");
		state2 = state1.replace("FD","M Full");
	}
	if (stats.lan_desc == '1') {
		code += '<td class="title indent2" style="text-align:center">' + state + state2 + '<\/td>';
	} else {
		code += '<td class="title indent2" style="text-align:center">' + state + '<\/td>';
	}

	code += '<td class="content"> <\/td><\/tr>';
	code += '<tr><td class="title indent1" colspan="7" align="right">&raquo; <a href="basic-network.asp">Configure<\/a><\/td><\/tr><\/table><\/div>';
	E("ports").innerHTML = code;
}

function anon_update()
{
	update = anonupdate.update;
	if (update == "no") { return 0; }

	var code = '<div class="section-title" style="text-align:center">!! Attention !!<\/div>';
	code += '<div class="fields" style="text-align:center">Newer version of Tomato ARM ' + update + ' is now available. <a class="new_window" href="https://exotic.se/tomato-arm">Click here to download<\/a>.<\/div>';
	code += '<\/div>';
	E("nversion").style.display = "block";
	E("nversion").innerHTML = code;
}

function show()
{
	c('cpu', stats.cpuload);
	c('cpupercent', stats.cpupercent);
	c('wlsense', stats.wlsense);
	c('uptime', stats.uptime);
	c('time', stats.time);
	c('memory', stats.memory);
	c('swap', stats.swap);
	elem.display('swap', stats.swap != '');

/* IPV6-BEGIN */
	c('ip6_wan', stats.ip6_wan);
	elem.display('ip6_wan', stats.ip6_wan != '');
	c('ip6_lan', stats.ip6_lan);
	elem.display('ip6_lan', stats.ip6_lan != '');
	c('ip6_lan_ll', stats.ip6_lan_ll);
	elem.display('ip6_lan_ll', stats.ip6_lan_ll != '');
/* IPV6-END */

	for (uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
		var u = (uidx > 1) ? uidx : '';
		c('wan'+u+'ip', stats.wanip[uidx-1]);
		c('wan'+u+'netmask', stats.wannetmask[uidx-1]);
		c('wan'+u+'gateway', stats.wangateway[uidx-1]);
		c('wan'+u+'dns', stats.dns[uidx-1]);
		c('wan'+u+'status', stats.wanstatus[uidx-1]);
		c('wan'+u+'uptime', stats.wanuptime[uidx-1]);
		if (show_dhcpc[uidx-1]) c('wan'+u+'lease', stats.wanlease[uidx-1]);
		if (show_codi[uidx-1]) {
			E('b'+u+'_connect').disabled = stats.wanup[uidx-1];
			E('b'+u+'_disconnect').disabled = !stats.wanup[uidx-1];
		}
	}

	for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		if (wl_sunit(uidx)<0) {
			c('radio'+uidx, wlstats[uidx].radio ? 'Enabled' : '<b>Disabled<\/b>');
			c('rate'+uidx, wlstats[uidx].rate);
			if (show_radio[uidx]) {
				E('b_wl'+uidx+'_enable').disabled = wlstats[uidx].radio;
				E('b_wl'+uidx+'_disable').disabled = !wlstats[uidx].radio;
			}
			c('channel'+uidx, stats.channel[uidx]);
			if (nphy) {
				c('nbw'+uidx, wlstats[uidx].nbw);
			}
			c('interference'+uidx, stats.interference[uidx]);
			elem.display('interference'+uidx, stats.interference[uidx] != '');

			if (wlstats[uidx].client) {
				c('rssi'+uidx, wlstats[uidx].rssi || '');
				c('noise'+uidx, wlstats[uidx].noise || '');
				c('qual'+uidx, stats.qual[uidx] || '');
			}
		}
		c('ifstatus'+uidx, wlstats[uidx].ifstatus || '');
	}
}

function earlyInit()
{
	if ((stats.anon_enable == '-1') || (stats.anon_answer == '0'))
		E('att1').style.display = '';

	var uidx;
	for (uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
		var u = (uidx > 1) ? uidx : '';
		elem.display('b'+u+'_dhcpc', show_dhcpc[uidx-1]);
		elem.display('b'+u+'_connect', 'b'+u+'_disconnect', show_codi[uidx-1]);
		elem.display('wan'+u+'-title', 'sesdiv_wan'+u, (nvram['wan'+u+'_proto'] != 'disabled'));
	}
	for (uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		if (wl_sunit(uidx)<0)
			elem.display('b_wl'+uidx+'_enable', 'b_wl'+uidx+'_disable', show_radio[uidx]);
	}

	ethstates();

	anon_update()

	show();
}

function init()
{
	var c;
	if (((c = cookie.get('status_overview_system_vis')) != null) && (c != '1')) toggleVisibility("system");
	for (var uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
		var u = (uidx>1) ? uidx : '';
		if (((c = cookie.get('status_overview_wan'+u+'_vis')) != null) && (c != '1')) toggleVisibility("wan"+u);
		}
	if (((c = cookie.get('status_overview_lan_vis')) != null) && (c != '1')) toggleVisibility("lan");
	for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		u = wl_unit(uidx);
		if (((c = cookie.get('status_overview_wl_'+u+'_vis')) != null) && (c != '1')) toggleVisibility("wl_"+u);
	}
	ref.initPage(3000, 3);

	var elements = document.getElementsByClassName("new_window");
	for (var i = 0; i < elements.length; i++) if (elements[i].nodeName.toLowerCase()==="a")
		addEvent(elements[i], "click", function(e) { cancelDefaultAction(e); window.open(this,"_blank"); } );
}

function toggleVisibility(whichone) {
	if (E('sesdiv_' + whichone).style.display == '') {
		E('sesdiv_' + whichone).style.display = 'none';
		E('sesdiv_' + whichone + '_showhide').innerHTML = '(show)';
		cookie.set('status_overview_' + whichone + '_vis', 0);
	} else {
		E('sesdiv_' + whichone).style.display='';
		E('sesdiv_' + whichone + '_showhide').innerHTML = '(hide)';
		cookie.set('status_overview_' + whichone + '_vis', 1);
	}
}

</script>

</head>
<body onload='init()'>
<form action=''>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->
<div class='section' id='nversion' style='display:none'></div>

<div style='display:none' id='att1'>
<div class='section-title' style="text-align:center">!! Attention !!</div>
<div class='fields' style="text-align:center">You did not configure <b>TomatoAnon project</b> setting.
<br />Please go to <a href='admin-tomatoanon.asp'>TomatoAnon configuration page</a> and make a choice.</div>
<br />
</div>

<div class='section-title'>System <small><i><a href='javascript:toggleVisibility("system");'><span id='sesdiv_system_showhide'>(hide)</span></a></i></small></div>
<div class='section' id='sesdiv_system'>
<script type='text/javascript'>
var a = nvstat.free / nvstat.size * 100.0;
createFieldTable('', [
	{ title: 'Name', text: nvram.router_name },
	{ title: 'Model', text: nvram.t_model_name },
	{ title: 'Chipset', text: stats.systemtype },
	{ title: 'CPU Frequency', text: stats.cpumhz, suffix: ' <small>(dual-core)<\/small>' },
	{ title: 'Flash Size', text: stats.flashsize },
	null,
	{ title: 'Time', rid: 'time', text: stats.time },
	{ title: 'Uptime', rid: 'uptime', text: stats.uptime },
	{ title: 'CPU Usage', rid: 'cpupercent', text: stats.cpupercent },
	{ title: 'CPU Load <small>(1 / 5 / 15 mins)<\/small>', rid: 'cpu', text: stats.cpuload },
	{ title: 'Total / Free Memory', rid: 'memory', text: stats.memory },
	{ title: 'Total / Free Swap', rid: 'swap', text: stats.swap, hidden: (stats.swap == '') },
	{ title: 'Total / Free NVRAM', text: scaleSize(nvstat.size) + ' / ' + scaleSize(nvstat.free) + ' <small>(' + (a).toFixed(2) + '%)<\/small>' },
	null,
	{ title: 'CPU Temperature', rid: 'temps', text: stats.cputemp + 'C'},
	{ title: 'Wireless Temperature', rid: 'wlsense', text: stats.wlsense }
]);
</script>
</div>

<div class='section' id='ports'>
</div>

<script type='text/javascript'>
for (var uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
	var u = (uidx>1) ? uidx : '';
	W('<div class=\'section-title\' id=\'wan'+u+'-title\'>WAN'+u+' <small><i><a href=\'javascript:toggleVisibility("wan' + u + '");\'><span id=\'sesdiv_wan' +u + '_showhide\'>(hide)<\/span><\/a><\/i><\/small><\/div>');
	W('<div class=\'section\' id=\'sesdiv_wan'+u+'\'>');
	createFieldTable('', [
		{ title: 'MAC Address', text: nvram['wan'+u+'_hwaddr'] },
		{ title: 'Connection Type', text: { 'dhcp':'DHCP', 'static':'Static IP', 'pppoe':'PPPoE', 'pptp':'PPTP', 'l2tp':'L2TP', 'ppp3g':'3G Modem', 'lte':'4G/LTE' }[nvram['wan'+u+'_proto']] || '-' },
		{ title: 'IP Address', rid: 'wan'+u+'ip', text: stats.wanip[uidx-1] },
		{ title: 'Subnet Mask', rid: 'wan'+u+'netmask', text: stats.wannetmask[uidx-1] },
		{ title: 'Gateway', rid: 'wan'+u+'gateway', text: stats.wangateway[uidx-1] },
/* IPV6-BEGIN */
	{ title: 'IPv6 Address', rid: 'ip6_wan', text: stats.ip6_wan, hidden: (stats.ip6_wan == '') },
/* IPV6-END */
		{ title: 'DNS', rid: 'wan'+u+'dns', text: stats.dns[uidx-1] },
		{ title: 'MTU', text: nvram['wan'+u+'_run_mtu'] },
		null,
		{ title: 'Status', rid: 'wan'+u+'status', text: stats.wanstatus[uidx-1] },
		{ title: 'Connection Uptime', rid: 'wan'+u+'uptime', text: stats.wanuptime[uidx-1] },
		{ title: 'Remaining Lease Time', rid: 'wan'+u+'lease', text: stats.wanlease[uidx-1], ignore: !show_dhcpc[uidx-1] }
	]);
	W('<span id=\'b'+u+'_dhcpc\' style=\'display:none\'>');
	W('<input type=\'button\' class=\'controls\' onclick=\'dhcpc("renew","wan'+u+'")\' value=\'Renew\'> &nbsp;');
	W('<input type=\'button\' class=\'controls\' onclick=\'dhcpc("release","wan'+u+'")\' value=\'Release\'> &nbsp;');
	W('<\/span>');
	W('<input type=\'button\' class=\'controls\' onclick=\'wan_connect('+uidx+')\' value=\'Connect\' id=\'b'+u+'_connect\' style=\'display:none\'>');
	W('<input type=\'button\' class=\'controls\' onclick=\'wan_disconnect('+uidx+')\' value=\'Disconnect\' id=\'b'+u+'_disconnect\' style=\'display:none\'>');
	W('<\/div>');
}
</script>

<div class='section-title'>LAN <small><i><a href='javascript:toggleVisibility("lan");'><span id='sesdiv_lan_showhide'>(hide)</span></a></i></small></div>
<div class='section' id='sesdiv_lan'>
<script type='text/javascript'>

function h_countbitsfromleft(num) {
	if (num == 255 ){
		return(8);
	}
	var i = 0;
	var bitpat=0xff00; 
	while (i < 8){
		if (num == (bitpat & 0xff)){
			return(i);
		}
		bitpat=bitpat >> 1;
		i++;
	}
	return(Number.NaN);
}

function numberOfBitsOnNetMask(netmask) {
	var total = 0;
	var t = netmask.split('.');
	for (var i = 0; i<= 3 ; i++) {
		total += h_countbitsfromleft(t[i]);
	}
	return total;
}

var s='';
var t='';
for (var i = 0 ; i <= MAX_BRIDGE_ID ; i++) {
	var j = (i == 0) ? '' : i.toString();
	if (nvram['lan' + j + '_ifname'].length > 0) {
		if (nvram['lan' + j + '_proto'] == 'dhcp') {
			if ((!fixIP(nvram.dhcpd_startip)) || (!fixIP(nvram.dhcpd_endip))) {
				var x = nvram['lan' + j + '_ipaddr'].split('.').splice(0, 3).join('.') + '.';
				nvram['dhcpd' + j + '_startip'] = x + nvram['dhcp' + j + '_start'];
				nvram['dhcpd' + j + '_endip'] = x + ((nvram['dhcp' + j + '_start'] * 1) + (nvram['dhcp' + j + '_num'] * 1) - 1);
			}
			s += ((s.length>0)&&(s.charAt(s.length-1) != ' ')) ? '<br />' : '';
			s += '<b>br' + i + '<\/b> (LAN' + j + ') - ' + nvram['dhcpd' + j + '_startip'] + ' - ' + nvram['dhcpd' + j + '_endip'];
		} else {
			s += ((s.length>0)&&(s.charAt(s.length-1) != ' ')) ? '<br />' : '';
			s += '<b>br' + i + '<\/b> (LAN' + j + ') - Disabled';
		}
		t += ((t.length>0)&&(t.charAt(t.length-1) != ' ')) ? '<br />' : '';
		t += '<b>br' + i + '<\/b> (LAN' + j + ') - ' + nvram['lan' + j + '_ipaddr'] + '/' + numberOfBitsOnNetMask(nvram['lan' + j + '_netmask']);
		
	}
}

createFieldTable('', [
	{ title: 'Router MAC Address', text: nvram.et0macaddr },
	{ title: 'Router IP Addresses', text: t },
	{ title: 'Gateway', text: nvram.lan_gateway, ignore: nvram.wan_proto != 'disabled' },
/* IPV6-BEGIN */
	{ title: 'Router IPv6 Address', rid: 'ip6_lan', text: stats.ip6_lan, hidden: (stats.ip6_lan == '') },
	{ title: 'IPv6 Link-local Address', rid: 'ip6_lan_ll', text: stats.ip6_lan_ll, hidden: (stats.ip6_lan_ll == '') },
/* IPV6-END */
	{ title: 'DNS', rid: 'dns', text: stats.dns, ignore: nvram.wan_proto != 'disabled' },
	{ title: 'DHCP', text: s }
]);

</script>
</div>

<script type='text/javascript'>
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
/* REMOVE-BEGIN
//	u = wl_unit(uidx);
REMOVE-END */
	u = wl_fface(uidx);
	W('<div class=\'section-title\' id=\'wl'+u+'-title\'>Wireless');
	if (wl_ifaces.length > 0)
		W(' (' + wl_display_ifname(uidx) + ')');
	W(' <small><i><a href=\'javascript:toggleVisibility("wl_' + u + '");\'><span id=\'sesdiv_wl_' +u + '_showhide\'>(hide)<\/span><\/a><\/i><\/small>');
	W('<\/div>');
	W('<div class=\'section\' id=\'sesdiv_wl_'+u+'\'>');
	sec = auth[nvram['wl'+u+'_security_mode']] + '';
	if (sec.indexOf('WPA') != -1) sec += ' + ' + enc[nvram['wl'+u+'_crypto']];

	wmode = wmo[nvram['wl'+u+'_mode']] + '';
	if ((nvram['wl'+u+'_mode'] == 'ap') && (nvram['wl'+u+'_wds_enable'] * 1)) wmode += ' + WDS';

	createFieldTable('', [
		{ title: 'MAC Address', text: nvram['wl'+u+'_hwaddr'] },
		{ title: 'Wireless Mode', text: wmode },
		{ title: 'Wireless Network Mode', text: bgmo[nvram['wl'+u+'_net_mode']], ignore: (wl_sunit(uidx)>=0) },
		{ title: 'Interface Status', rid: 'ifstatus'+uidx, text: wlstats[uidx].ifstatus },
		{ title: 'Radio', rid: 'radio'+uidx, text: (wlstats[uidx].radio == 0) ? '<b>Disabled<\/b>' : 'Enabled', ignore: (wl_sunit(uidx)>=0) },
/* REMOVE-BEGIN */
//	{ title: 'SSID', text: (nvram['wl'+u+'_ssid'] + ' <small><i>' + ((nvram['wl'+u+'_mode'] != 'ap') ? '' : ((nvram['wl'+u+'_closed'] == 0) ? '(Broadcast Enabled)' : '(Broadcast Disabled)')) + '<\/i><\/small>') },
/* REMOVE-END */
		{ title: 'SSID', text: nvram['wl'+u+'_ssid'] },
		{ title: 'Broadcast', text: (nvram['wl'+u+'_closed'] == 0) ? 'Enabled' : '<b>Disabled<\/b>', ignore: (nvram['wl'+u+'_mode'] != 'ap') },
		{ title: 'Security', text: sec },
		{ title: 'Channel', rid: 'channel'+uidx, text: stats.channel[uidx], ignore: (wl_sunit(uidx)>=0) },
		{ title: 'Channel Width', rid: 'nbw'+uidx, text: wlstats[uidx].nbw, ignore: ((!nphy) || (wl_sunit(uidx)>=0)) },
		{ title: 'Interference Level', rid: 'interference'+uidx, text: stats.interference[uidx], hidden: ((stats.interference[uidx] == '') || (wl_sunit(uidx)>=0)) },
		{ title: 'Rate', rid: 'rate'+uidx, text: wlstats[uidx].rate, ignore: (wl_sunit(uidx)>=0) },
		{ title: 'RSSI', rid: 'rssi'+uidx, text: wlstats[uidx].rssi || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) },
		{ title: 'Noise', rid: 'noise'+uidx, text: wlstats[uidx].noise || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) },
		{ title: 'Signal Quality', rid: 'qual'+uidx, text: stats.qual[uidx] || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) }
	]);

	W('<input type=\'button\' class=\'controls\' onclick=\'wlenable('+uidx+', 1)\' id=\'b_wl'+uidx+'_enable\' value=\'Enable\' style=\'display:none\'>');
	W('<input type=\'button\' class=\'controls\' onclick=\'wlenable('+uidx+', 0)\' id=\'b_wl'+uidx+'_disable\' value=\'Disable\' style=\'display:none\'>');
	W('<\/div>');
}
</script>


<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
	<script type='text/javascript'>genStdRefresh(1,0,'ref.toggle()');</script>
</td></tr>
</table>
</form>
<script type='text/javascript'>earlyInit()</script>
</body>
</html>
