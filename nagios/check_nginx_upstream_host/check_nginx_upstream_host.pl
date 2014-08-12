#!/usr/bin/env perl

use strict;
use warnings;
use vars qw( $PROGNAME $VERSION );
use File::Glob ':glob';

use Nagios::Plugin;
use File::Basename qw( basename );

$VERSION = 'v0.0.1';
$PROGNAME = basename $0;

my $nagios = Nagios::Plugin->new(
    version   => $VERSION,
    plugin    => $PROGNAME,
    usage     => "Usage: %s --host|-h <host name> --conf|-C <nginx configuration file> --pool|-p <upstream pool name> [ --warning|-w --message|-m <error message> ]",
    blurb     => 'Check for host inside of nginx upstream pool',
    extra     => 'Written by Justin La Sotten',
    url       => 'http://www.github.com/justino/check_nginx_upstream_host',
    timeout   => 15,
);

$nagios->add_arg(
    spec     => 'host|h=s',
    help     => "--host <hostname or IP>\n   Host that we will be looking for",
    required => 1,
);

$nagios->add_arg(
    spec     => 'conf|C=s',
    help     => "--conf <path to nginx config file>\n   Nginx config file to look for upstream hosts in",
    required => 1,
);

$nagios->add_arg(
    spec => 'pool|p=s',
    help => "--pool <pool name>\n   Name of the upstream pool we want to make sure the host is inside",
    required => 1,
);

$nagios->add_arg(
    spec     => 'warning|w',
    help     => "--warning\n   Issue a WARNING if host is not found, default is CRITICAL",
    required => 0,
);

$nagios->add_arg(
    spec     => 'message|m=s',
    help     => "--message <message>\n   Use this message as the output of a failure",
    required => 0,
);

$nagios->getopts;

my $failure_level = $nagios->opts->warning ? WARNING : CRITICAL;

if (find_host_in_pool(read_config($nagios->opts->conf), $nagios->opts->pool, $nagios->opts->host)) {
    $nagios->nagios_exit(OK, 'Found in running nginx config');
}
else {
    $nagios->nagios_exit($failure_level, $nagios->opts->message || 'Not found in running nginx config');
}

$nagios->nagios_exit(UNKNOWN, 'Premature unknown exit');

sub read_config {
    my $conf_file = shift;
    my $config_contents;
    
    open(my $fh, '<', $conf_file)
        or $nagios->nagios_exit(UNKNOWN, "Unable to parse nginx config file: " . $!);
        
    while (my $line = <$fh>) {
        ## Discard comments
        next if $line =~ /^#/;
        
        ## Check for an include directive
        ## If present, recursively read those files and build a full config file
        if ($line =~ /^\s*include\s+(.+)\s*;\s*$/i) {
            my @includes = glob $1;
            
            for my $include_file (@includes) {
                $config_contents .= read_config($include_file);
            }
        }
        else {
            $config_contents .= $line;
        }
    }
        
    close $fh;
    
    return $config_contents;
}

sub find_host_in_pool {
    my ($config, $upstream_pool, $host) = @_;
    
    ## Find the pool
    $config =~ /upstream\s+$upstream_pool\s*\{(.+?)\}/sm;
    my $pool = $1;
    
    if (! $pool) {
        $nagios->nagios_exit(UNKNOWN, "Unable to locate upstream pool: $upstream_pool");
    }
    
    ## Find the host in the pool
    return $pool =~ /server\s+$host:/m;
}
