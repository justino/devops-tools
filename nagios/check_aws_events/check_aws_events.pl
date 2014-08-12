#!/usr/bin/env perl

use strict;
use warnings;
use vars qw( $PROGNAME $VERSION );

use Nagios::Plugin;
use File::Basename qw( basename );

use Data::Dumper;

$VERSION = 'v0.0.1';
$PROGNAME = basename $0;

my $nagios = Nagios::Plugin->new(
    version     => $VERSION,
    plugin      => $PROGNAME,
    usage       => 'Usage: %s [ --warning|-w --message|-m <error message> ]',
    blurb       => 'Check current host for AWS Events',
    extra       => 'Written by Justin La Sotten',
    url         => 'https://github.com/justino/check_aws_events',
    timeout     => 15,
);

$nagios->add_arg(
    spec        => 'warning|w',
    help        => "--warning\n\tIssue a WARNING if host has active Events. Default us CRITICAL",
    required    => 0,
);

$nagios->add_arg(
    spec        => 'message|m=s',
    help        => "--message <message>\n\tUse this message as the output of a failure",
    required    => 0,
);

$nagios->getopts;

## Choose failure level based on command line options, CRITICAL is default
my $failure_level = $nagios->opts->warning ? WARNING : CRITICAL;

## Find AWS Events, return 
my @events = find_aws_events();

## Format the events into a nice to read string
my ($event_reason, @event_reasons);
for my $event (@events) {
    push @event_reasons, format_event($event);
}
$event_reason = join ', ', @event_reasons;

## Add performance metrics
$nagios->add_perfdata(
    label   => 'events',
    value   => scalar @event_reasons,
);

## Time to spit out the nagios result
if (scalar @event_reasons) {
    $nagios->nagios_exit($failure_level, $nagios->opts->message || $event_reason);
}
else {
    $nagios->nagios_exit(OK, 'No Events Scheduled');
}

$nagios->nagios_exit(UNKNOWN, 'Premature unknown exit');

sub find_aws_events {
    ## Fetch the current instance id from AWS metadata API
    ## http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AESDG-chapter-instancedata.html
    my $instance_id = `curl -s http://169.254.169.254/latest/meta-data/instance-id`;
    
    ## Use AWS tools to fetch instance events that are not completed
    my $status = `ec2-describe-instance-status $instance_id | grep 'EVENT' | grep -v '\\[Completed\\]'`;
    
    ## No status, no events :)
    return () if ! $status;
    
    ## Return an array of status (in case there are more than one
    return split /\n/, $status;
}

sub format_event {
    my $event = shift;
    
    ## Event format example
    ## EVENT	system-maintenance	2013-08-06T07:00:00+0000	2013-08-06T11:00:00+0000	Your instance network connections will be restarted during this window.
    my @fields = split /\t/, $event;
    
    return "[$fields[1]] $fields[4]";
}
