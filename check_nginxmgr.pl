#!/usr/bin/env perl

use strict;
use warnings;
use vars qw( $PROGNAME $VERSION );
use File::Basename qw( basename );

use Nagios::Plugin;
use RPC::XML::Client;
use Data::Dumper;

$VERSION = 'v0.0.1';
$PROGNAME = basename $0;

my $nagios = Nagios::Plugin->new(
    version => $VERSION,
    plugin  => $PROGNAME,
    usage   => 'Usage: %s --host|-h <host name> [ --port|-p <port number> ]',
    blurb   => 'Check if Nginxmgr is alive',
    extra   => 'Written by Justin La Sotten',
    url     => 'http://www.github.com/justino/check_nginxmgr',
    timeout => 15,
);

$nagios->add_arg(
    spec     => 'host|h=s',
    help     => '--host <hostname or ip>\n   Host that has Nginxmgr running on it',
    required => 1,
);

$nagios->add_arg(
    spec    => 'port|p=i',
    help    => '--port <port number>\n   Port that Nginxmgr is configured to run on',
    required => 0,
    default => '9000',
);

$nagios->add_arg(
    spec => 'warning|w',
    help => '--warning\n   Issue a WARNING if Nginxmgr is not responding, default is CRITICAL',
    required => 0,
);

$nagios->getopts;

my $failure_level = $nagios->opts->warning ? WARNING : CRITICAL;

my $rpc = rpc_connect($nagios->opts->host, $nagios->opts->port);
my $pools = get_pools();

$nagios->nagios_exit(OK, 'Nginxmgr is responding') if $pools;
$nagios->nagios_exit($failure_level, 'Nginxmgr does not appear to be responding');

sub get_pools {
    return $rpc->simple_request('get_pools');
}

sub rpc_connect {
    my ($host, $port) = @_;
    
    return RPC::XML::Client->new("http://$host:$port");
}

exit;