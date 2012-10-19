package Tapper::Testplan::Reporter;
BEGIN {
  $Tapper::Testplan::Reporter::AUTHORITY = 'cpan:AMD';
}
{
  $Tapper::Testplan::Reporter::VERSION = '4.1.0';
}
# ABSTRACT: Main module for testplan reporting

use warnings;
use strict;
use 5.010;

use Moose;
use Tapper::Config;
use Tapper::Model 'model';
use Hash::Merge 'merge';
use Tapper::Testplan::Utils;

extends 'Tapper::Testplan';


sub run
{
        my ($self, @tasks)    = @_;
        my $plugin    = Tapper::Config->subconfig->{testplans}{reporter}{plugin}{name} || 'Taskjuggler';
        my $intervall;

        eval "use Tapper::Testplan::Plugins::$plugin";
        my $reporter = "Tapper::Testplan::Plugins::$plugin"->new(cfg => Tapper::Config->subconfig->{testplans}{reporter}{plugin});
        my $util     = Tapper::Testplan::Utils->new();

        my @reports;

        if (not @tasks) {
                @tasks     = $reporter->get_tasks();
                $intervall = Tapper::Config->subconfig->{testplans}{reporter}{interval};
        }

 TASK:
        foreach my $task (@tasks) {

                my $task_success = $util->get_testplan_success($task->{path}, $intervall);
                 Hash::Merge::set_behavior( 'LEFT_PRECEDENT' );
                $task = merge($task, $task_success);
                push @reports, $task;
        }
        $reporter->send_reports(@reports);
}

1; # End of Tapper::Testplan::Reporter

__END__
=pod

=encoding utf-8

=head1 NAME

Tapper::Testplan::Reporter - Main module for testplan reporting

=head1 SYNOPSIS

    use Tapper::Testplan::Reporter;

    my $foo = Tapper::Testplan::Reporter->new();

=head1 FUNCTIONS

=head2 run

Get the tasks to report and do the reporting.

@optparam array - list of tasks names

=head1 AUTHOR

AMD OSRC Tapper Team <tapper@amd64.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Advanced Micro Devices, Inc..

This is free software, licensed under:

  The (two-clause) FreeBSD License

=cut

