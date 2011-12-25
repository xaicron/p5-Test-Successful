use strict;
use warnings;
use Test::Successful;
use Test::More;

plan tests => 100;

ok 0;
fail;
TODO: {
    local $TODO = 'foo';
    fail;
}

SKIP: {
    skip foo => 2;
    ok 0;
    die "oops!!";
}

done_testing(2000);
