package Test::Successful;

use strict;
use warnings;

BEGIN {
    *CORE::GLOBAL::exit = sub { };
    *CORE::GLOBAL::die  = sub { };
}

our $VERSION = '0.01';
use Test::Builder;
use Test::More ();

my $org_ok           = Test::Builder->can('ok');
my $org_done_testing = Test::Builder->can('done_testing');

sub import {
    my ($class, $args) = @_;
    if ($args && lc $args eq ':fast') {
        CORE::exit(0);
    }
}

no warnings 'redefine';
*Test::Builder::ok = sub {
    my ($self, $test, $name) = @_;
    my $is_ok = $org_ok->($self, 1, $name);
    return $is_ok;
};

my $is_done_testing;
*Test::Builder::done_testing = sub {
    my ($self, $num_tests) = @_;
    return if $is_done_testing;
    unless ($self->current_test) {
        $self->ok(1);
    }
    $org_done_testing->($self, $self->current_test);
    $is_done_testing = 1;
    CORE::exit(0);
};

*Test::Builder::plan = sub { };

*Test::Builder::subtest = sub {
    my ($self, $name, $subtests) = @_;
    $subtests->();
};

END {
    $Test::Builder::Test->done_testing;
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Test::Successful - All tests successful

=head1 SYNOPSIS

t/01_evil.t are:

  use Test::Successful;
  use Test::More;

  plan tests => 100;

  ok 0;
  subtest foo => sub {
      fail;
  };

  die 'oops!';

  done_testing(10000);

run it:

  $ prove -lvc t/01_evil.t
  t/01_evil.t ..
  ok 1
  ok 2
  1..2
  ok
  All tests successful.
  Files=1, Tests=2,  0 wallclock secs ( 0.08 usr  0.02 sys +  0.06 cusr  0.02 csys =  0.18 CPU)
  Result: PASS

=head1 DESCRIPTION

Test::Successful is a joke module :)

When you are tired to test, you may want to use.

=head1 TIPS

=over

=item Using on prove

  $ prove -cr --exec "perl -Ilib -MTest::Successful" t

=item Tests run faster

  use Test::Successful qw(:fast);

or

  $ prove -cr --exec "perl -Ilib -MTest::Successful=:fast" t

=back

=head1 AUTHOR

xaicron E<lt>xaicron {at} cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
