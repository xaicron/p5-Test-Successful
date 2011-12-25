use inc::Module::Install;
use Module::Install::AuthorTests;

name 'Test-Successful';
all_from 'lib/Test/Successful.pm';

#requires '';

test_requires 'Test::More', 0.98;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

repository 'http://github.com/xaicron/p5-Test-Successful/';
bugtracker 'http://github.com/xaicron/p5-Test-Successful/issues';

WriteAll;
