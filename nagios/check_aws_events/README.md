check_aws_events.pl v0.0.1
==========================
https://github.com/justino/check_aws_events

This nagios plugin is free software, and comes with ABSOLUTELY NO WARRANTY. 
It may be used, redistributed and/or modified under the terms of the GNU 
General Public Licence (see http://www.fsf.org/licensing/licenses/gpl.txt).

Check current host for AWS Events

    Usage: check_aws_events.pl [ --warning|-w --message|-m <error message> ]

    -?, --usage
      Print usage information
    -h, --help
      Print detailed help screen
    -V, --version
      Print version information
    --extra-opts=[section][@file]
      Read options from an ini file. See http://nagiosplugins.org/extra-opts
      for usage and examples.
    --warning
      Issue a WARNING if host has active Events. Default us CRITICAL
    --message <message>
      Use this message as the output of a failure
    -t, --timeout=INTEGER
      Seconds before plugin times out (default: 15)
    -v, --verbose
      Show details for command-line debugging (can repeat up to 3 times)

Written by Justin La Sotten

