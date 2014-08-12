#!/usr/bin/env perl

use strict;
use warnings;
use vars qw( $PROGNAME $VERSION );
use File::Basename qw( basename );

use Nagios::Plugin;

$VERSION = 'v0.0.1';
$PROGNAME = basename $0;

my $nagios = Nagios::Plugin->new(
    version => $VERSION,
    plugin  => $PROGNAME,
    usage   => '',
    blurb   => '',
    extra   => '',
    url     => '',
    timeout => 15,
);

$nagios->add_arg(
    spec     => '',
    help     => '',
    required => 1,
);

$nagios->getopts;

exit;