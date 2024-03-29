package Tapper::Testplan::Generator;
BEGIN {
  $Tapper::Testplan::Generator::AUTHORITY = 'cpan:TAPPER';
}
{
  $Tapper::Testplan::Generator::VERSION = '4.1.2';
}
# ABSTRACT: Main module for generating testplan instances

use warnings;
use strict;
use 5.010;

use Tapper::Config;
use Tapper::Model 'model';
use File::Slurp 'slurp';
use Moose;
use Tapper::Cmd::Testplan;
use Template;

extends 'Tapper::Testplan';


sub apply_macro
{
        my ($self, $macro, $substitutes) = @_;


        my @include_paths = (Tapper::Config->subconfig->{paths}{testplan_path});
        my $include_path_list = join ":", @include_paths;

        my $tt = Template->new({
                               INCLUDE_PATH =>  $include_path_list,
                               });
        my $ttapplied;

        $tt->process(\$macro, $substitutes, \$ttapplied) || die $tt->error();
        return $ttapplied;
}




sub run
{
        my ($self, $force)    = @_;
        my $plugin    = Tapper::Config->subconfig->{testplans}{generator}{plugin}{name} || 'Taskjuggler';
        my $now       = time();
        my $intervall = Tapper::Config->subconfig->{testplans}{generator}{interval};

        eval "use Tapper::Testplan::Plugins::$plugin";
        my $reporter = "Tapper::Testplan::Plugins::$plugin"->new(cfg => Tapper::Config->subconfig->{testplans}{reporter}{plugin});

        my @instances;
 TASK:
        foreach my $task ($reporter->get_tasks()) {

                my $path  = $task->{path};
                my $name  = $task->{name};

                my $instances = model('TestrunDB')->resultset('TestplanInstance')->search
                  ({ path => $path,
                     created_at => { '>=' => $now - $intervall }});

                next TASK if $instances->count and not $force;

                my $file = Tapper::Config->subconfig->{paths}{testplan_path}.$path;
                next TASK unless -e $file;

                my $plan = slurp($file);
                $plan = $self->apply_macro($plan);
                my $cmd = Tapper::Cmd::Testplan->new();
                push @instances, $cmd->add($plan, $path, $name);
        }
        return @instances;
}

1; # End of Tapper::Testplan::Generator

__END__

=pod

=encoding utf-8

=head1 NAME

Tapper::Testplan::Generator - Main module for generating testplan instances

=head1 SYNOPSIS

    use Tapper::Testplan::Generator;

    my $foo = Tapper::Testplan::Generator->new();
    $foor->run();

=head1 FUNCTIONS

=head2 apply_macro

Apply macros on test plan content.

@param string  - contains macros
@param hashref - containing substitutions

@return success - text with applied macros
@return error   - die with error string

=head2 run

Create test plan instances based on task list given by plugin and the
test plans found in file system hierarchy. Test plans are created for
tasks that did not have any new test plan instance within the last
interval (configurable) or for all tasks if force option is given.

@param bool - force creation of test plans for all tasks

=head1 AUTHOR

AMD OSRC Tapper Team <tapper@amd64.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Advanced Micro Devices, Inc..

This is free software, licensed under:

  The (two-clause) FreeBSD License

=cut
