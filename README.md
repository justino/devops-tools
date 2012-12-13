check_aws_status v0.0.1

This nagios plugin is free software, and comes with ABSOLUTELY NO WARRANTY. 
It may be used, redistributed and/or modified under the terms of the GNU 
General Public Licence (see http://www.fsf.org/licensing/licenses/gpl.txt).

Check AWS Services Health

    Usage: check_aws_status [ --warning|-w --url|-u <rss feed url> --zone|-z <AWS zone> ]

    -?, --usage
    Print usage information
    -h, --help
    Print detailed help screen
    -V, --version
    Print version information
    --extra-opts=[section][@file]
    Read options from an ini file. See http://nagiosplugins.org/extra-opts
    for usage and examples.
    --url
    Specify the RSS feed to parse, defaults to ALL
    --zone
    Specify zone we are interested in, will try to restrict alerts to specific zone
    --warning
    Issue a WARNING if service is degradated, default is CRITICAL
    -t, --timeout=INTEGER
    Seconds before plugin times out (default: 15)
    -v, --verbose
    Show details for command-line debugging (can repeat up to 3 times)

Written by Justin La Sotten
