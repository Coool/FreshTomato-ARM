Using the DNSCrypt client on Windows
====================================

`dnscrypt-proxy` is DNSCrypt client that works on many platforms,
including Windows.

It doesn't provide any user interface, and has to be set up using the
command-line.

Independent projects such as [DNSCrypt Windows Service Manager](https://simonclausen.dk/projects/dnscrypt-winservicemgr/)
provide a user interface on top of `dnscrypt-proxy`, so that the core
client code can always be up-to-date, and the same as other platforms.

However, using `dnscrypt-proxy` directly is fairly simple and opens a
lot of options.

Quickstart
----------

1) Download and extract the latest
[Windows package for dnscrypt](https://download.dnscrypt.org/dnscrypt-proxy/LATEST-win32-full.zip).

2) Copy the `dnscrypt-proxy-win32` folder anywhere.

3) Look at the list of [public DNS resolvers supporting DNSCrypt](https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv)
and pick the one you want to use. Note its name, in the first column
(for example: `dnscrypt.org-fr`).

4) Open an elevated command prompt (see below), enter the
`dnscrypt-proxy-win32` folder and type:

    dnscrypt-proxy -R <name> --test=0

Replace `<name>` with name of the resolver you chose.

This command just tests if everything is properly installed on your
end, and if the resolver is properly working. If everything looks fine,
the command should display the server key fingerprint and exit right away.

If an error is displayed, retry with a different server.

5) So far, so good? Now, enable the service for real, by replacing the
`--test=0` part of the previous command with `--install`.

    dnscrypt-proxy -R <name> --install

6) Open the network preferences ("Network connections", then select
your network adapter and hit "Properties"). Then in the "Internet Protocol
Version 4 (TCP/IPv4)" settings use `127.0.0.1` instead of the default DNS
resolver address.

Congratulations, you're now using DNSCrypt!

IPv6
----

Do you have IPv6 connectivity? No problem!

In the preferences pane for a given network connection, Windows has
IPv6-specific settings under "Internet Protocol Version 6 (TCP/IPv6)".

The DNS server addresses have to be IPv6 addresses, so enter the
IPv6 representation of `127.0.0.1`:

    ::FFFF:127.0.0.1

Done. You can now enjoy the DNSCrypt proxy both for IPv4 and IPv6
connections.

How to open an elevated command prompt
--------------------------------------

On Windows 8.1 and Windows 10, press the Windows key + the X key and
select "Windows Command Prompt (Admin)" or "Windows PowerShell (Admin)".

If you get the message:

    [ERROR] Unable to bind (UDP) [Address already in use [WSAEADDRINUSE ]]

chances are that you tried to start the proxy from a limited
(non-elevated) command prompt.

Temporarily disabling DNSCrypt
------------------------------

`dnscrypt-proxy` receives DNS queries from your applications on
`127.0.0.1` (by default), wraps them into DNSCrypt queries, forwards
them to the real DNS resolver, securely receives and verifies the
responses, and forwards the legitimate ones to your client applications.

If you changed the DNS settings for a given network interface to
`127.0.0.1`, you can revert these settings to what they used to be (or
to any non-DNSCrypt resolver) anytime in order to stop using DNSCrypt.
Changing the address back to `127.0.0.1` makes the network interface
use the DNSCrypt proxy again.

The Windows service
-------------------

On Windows, `dnscrypt-proxy` can run as a Windows service, and this is how it
was set up in the quickstart section above.

In addition to the command-line switches available on other platforms,
the Windows builds of the proxy add the following switches:

- `--install`: install the proxy as a service.
- `--uninstall`: uninstall the service (but not the software - the
service can be restarted later)

Example: how to try a different DNSCrypt resolver:

Step 1 - Uninstall the previous service:

    dnscrypt-proxy --uninstall

Step 2 - Reinstall/restart the service, with the new settings:

    dnscrypt-proxy -R <new name> --install

Sharing the proxy with the local network
----------------------------------------

By default, only the Windows machine running the proxy can use it.

However, it can be convenient to make it accessible from any device on
the local network. For example, smartphones and tablets can use the
Windows machine as a DNS resolver (which will actually be the DNSCrypt
proxy) instead of running DNSCrypt themselves.

In order to do so, just add the following option to the command-line:
`--local-address=0.0.0.0`.

That is:

    dnscrypt-proxy -R <name> --install --local-address=0.0.0.0

And use the IP address of the Windows machine in the DNS settings of
any devices of the local network.

Removing the software from the system
-------------------------------------

If this DNSCrypt client doesn't fit your needs, we are very sorry for
this, and we'd love to hear about how we could make it better.

So, go to the "Support" section of the
[DNSCrypt](https://dnscrypt.org/) site and tell us your story.

Removing `dnscrypt-proxy` from your system is straightforward.

Before doing so, make sure that the DNS settings of your network
interfaces have been restored to what they were before (which, most of
the time, is just "DHCP").

Then, uninstall the service:

    dnscrypt-proxy --uninstall

And delete the directory.

Advanced usage
--------------

Startup options should specified as subkeys from this registry key:
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dnscrypt-proxy\Parameters`

The service is named `dnscrypt-proxy`.

The following subkeys are recognized and should be self-explanatory:

    Plugins           (REG_MULTI_SZ)
    LocalAddress      (REG_SZ)
    ProviderKey       (REG_SZ)
    ProviderName      (REG_SZ)
    ResolverAddress   (REG_SZ)
    ResolverName      (REG_SZ)
    ResolversList     (REG_SZ)
    LogFile           (REG_SZ)
    EDNSPayloadSize   (DWORD)
    MaxActiveRequests (DWORD)
    TCPOnly           (DWORD)
    ClientKeyFile     (REG_SZ)
    EphemeralKeys     (DWORD)

For example, in order to listen to local address that is not the default
`127.0.0.1`, the key to put the custom IP address is
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dnscrypt-proxy\Parameters\LocalAddress`.

Mandatory entries to run `dnscrypt-proxy` as a Windows service are:
- `ResolversList`: has to be set to the full path to the `dnscrypt-resolvers.csv` file.
- `ResolverName`: has to be set to the resolver name to be used. See
the `dnscrypt-resolvers.csv` file for a list of compatible public resolvers.

These entries are automatically created/updated when installing the service.

Plugins should be listed as paths to the `.DLL` files, optionally
followed by a coma and plugin-specific arguments:

    dnscrypt-proxy -R <name> --plugin=libdcplugin_example_ldns_aaaa_blocking.dll
    dnscrypt-proxy -R <name> --plugin=libdcplugin_example_ldns_blocking.dll,--domains=C:\blacklisted-domains.txt

The service should be restarted after the registry has been updated.
