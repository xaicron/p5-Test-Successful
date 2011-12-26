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
my $is_fast;

sub import {
    my ($class, $args) = @_;
    if ($args && lc $args eq ':fast') {
        $is_fast = 1;
    }
}

no warnings 'redefine';
*Test::Builder::ok = sub {
    my ($self, $test, $name) = @_;
    my $is_ok = $org_ok->($self, 1, $name);
    CORE::exit(0) if $is_fast;
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

Test::Successful -

=head1 SYNOPSIS

  use Test::Successful;

=head1 DESCRIPTION

Test::Successful is

=head1 AUTHOR

xaicron E<lt>xaicron {at} cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
