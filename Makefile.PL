
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Tapper - Testplan support with TaskJuggler interoperability",
  "AUTHOR" => "AMD OSRC Tapper Team <tapper\@amd64.org>",
  "BUILD_REQUIRES" => {
    "Data::Dumper" => 0,
    "HTTP::Daemon" => 0,
    "HTTP::Status" => 0,
    "POSIX" => 0,
    "Tapper::Schema::TestTools" => 0,
    "Test::Differences" => 0,
    "Test::Fixture::DBIC::Schema" => 0,
    "Test::MockModule" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Tapper-Testplan",
  "EXE_FILES" => [],
  "LICENSE" => "open_source",
  "NAME" => "Tapper::Testplan",
  "PREREQ_PM" => {
    "CHI" => 0,
    "DateTime" => 0,
    "DateTime::Format::DateParse" => 0,
    "DateTime::Format::Natural" => 0,
    "DateTime::Format::Strptime" => 0,
    "Email::Sender::Simple" => 0,
    "Email::Sender::Transport::SMTP" => 0,
    "Email::Simple" => 0,
    "File::ShareDir" => 0,
    "File::Slurp" => 0,
    "File::Temp" => 0,
    "Hash::Merge" => 0,
    "Module::Find" => "0.11",
    "Moose" => 0,
    "Tapper::Cmd::Testplan" => 0,
    "Tapper::Config" => 0,
    "Tapper::Model" => 0,
    "Template" => 0,
    "Text::CSV::Slurp" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "4.1.0",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



