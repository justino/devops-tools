#!/usr/bin/env perl

use strict;
use warnings;

## Nagios passes these to the script
my ($state, $type, $attempt) = @ARGV;
my $pid_file = '/var/run/nginxmgr.pid';

if ($state && $state =~ /CRITICAL|WARNING/ && $type && $type eq 'SOFT' && $attempt && $attempt > 2) {
    my @signals = qw{ SIGTERM SIGINT SIGKILL };
    
    service_control('stop');
    
    for my $signal (@signals) {
        my $pid = get_pid();
        next if $pid = $$;
        last if ! is_process_running($pid);
        
        kill $signal, $pid if $pid;
        sleep 1;
    }
        
    delete_pid_file($pid_file) if check_pid_file($pid_file);
    
    service_control('start');
}

exit;

## Stop service
sub service_control {
    my $control = shift;
    
    `/sbin/service nginxmgr $control`;
}

## Find the PID of the running nginxmgr
sub get_pid {
    my $result = `ps ax | grep nginxmgr | grep -v grep | cut -d' ' -f1`;
    chomp $result;
    
    return $result;
}

## Check to see if the process is running, returns bool
sub is_process_running {
    my $pid = shift;
    
    return `ps ax | grep $pid | grep -v grep | wc -l`;
}

## Check to see if PID file exists, returns bools
sub check_pid_file {
    my $file = shift;
    
    return -f $file;
}

## Deletes PID file is it exists
sub delete_pid_file {
    my $file = shift;
    
    unlink $file;
}