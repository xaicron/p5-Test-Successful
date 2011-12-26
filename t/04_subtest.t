use strict;
use warnings;
use Test::Successful;
use Test::More;

subtest foo => sub {};

subtest bar => sub {
    fail;
    fail;
};
