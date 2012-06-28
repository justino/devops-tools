check_nginx_upstream_host.pl v0.0.1
http://www.github.com/justino/check_nginx_upstream_host
==============================================================================

This nagios plugin is free software, and comes with ABSOLUTELY NO WARRANTY. 
It may be used, redistributed and/or modified under the terms of the GNU 
General Public Licence (see http://www.fsf.org/licensing/licenses/gpl.txt).

Check for host inside of nginx upstream pool

    Usage: check_nginx_upstream_host.pl --host|-h <host name> --conf|-C <nginx configuration file> --pool|-p <upstream pool name> [ --warning|-w --message|-m <error message> ]

    -?, --usage
      Print usage information
    -h, --help
      Print detailed help screen
    -V, --version
      Print version information
    --extra-opts=[section][@file]
      Read options from an ini file. See http://nagiosplugins.org/extra-opts
      for usage and examples.
    --host <hostname or IP>
      Host that we will be looking for
    --conf <path to nginx config file>
      Nginx config file to look for upstream hosts in
    --pool <pool name>
      Name of the upstream pool we want to make sure the host is inside
    --warning
      Issue a WARNING if host is not found, default is CRITICAL
    --message <message>
      Use this message as the output of a failure
    -t, --timeout=INTEGER
      Seconds before plugin times out (default: 15)
    -v, --verbose
      Show details for command-line debugging (can repeat up to 3 times)

Written by Justin La Sotten

