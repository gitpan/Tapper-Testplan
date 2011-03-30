use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Testplan';
all_from 'lib/Tapper/Testplan.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'perl';

build_requires 'Test::More';
build_requires 'Test::Differences';
build_requires 'Test::MockModule';
build_requires 'Tapper::Schema';

author_requires 'Module::Install::WriteAll';

requires 'Moose' => 0;

requires 'Tapper::Cmd'                    => "3.000004";
requires 'Tapper::Config'                 => "3.000002";
requires 'Tapper::Model'                  => "3.000002";
requires 'CHI'                            => 0;
requires 'DateTime'                       => 0;
requires 'DateTime::Format::DateParse'    => 0;
requires 'Text::CSV::Slurp'               => 0;
requires 'DateTime'                       => 0;
requires 'DateTime::Format::DateParse'    => 0;
requires 'DateTime::Format::Natural'      => 0.91; # older versions don't parse "next monday at 0:00"
requires 'DateTime::Format::Strptime'     => 0;
requires 'Email::Sender::Simple'          => 0;
requires 'Email::Sender::Transport::SMTP' => 0;
requires 'Email::Simple'                  => 0;
requires 'File::ShareDir'                 => 0;
requires 'File::Slurp'                    => 0;
requires 'Moose'                          => 0;
requires 'Template'                       => 0;
requires 'Text::CSV::Slurp'               => 0;
requires 'WWW::Mechanize'                 => 0;

install_script glob('bin/*');
auto_install;

repository 'git://github.com/amd/Tapper-Testplan.git';
bugtracker 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Testplan';

WriteAll;
