use Test::More tests=>7;

require_ok ( 'overload' );
require_ok ( 'Moose' );
require_ok ( 'Scalar::Util' );

package ShittyOverload;
use Moose;
use overload '""' => sub { "overload" };

sub new { bless \my $foo, __PACKAGE__ }

package UsingMoose;
use Moose;
use MooseX::Types::Moose::Overload 'Str';

### Nothing

package InnocentMoose;
use Moose;
use MooseX::Types::Moose 'Str';

has 'foo' => ( isa => Str, is => 'rw', coerce => 1 );

package InnocentMooseXTypes;
use Moose;

has 'foo' => ( isa => 'Str', is => 'rw', coerce => 1 );

package main;

my $str = ShittyOverload->new;

TODO: {
	local $TODO = 'MXTMO Should work with classic Moose';
	my $NOTmxtmo = InnocentMoose->new;
	eval { $NOTmxtmo->foo($str) };
	like ( $@, qr/does not pass the type constraint/, "Classic Moose's attribute to overloaded object" );
	ok ( ! defined $NOTmxtmo->foo , "Attribute remains undefined" );
}

TODO: {
	local $TODO = 'MXTMO Should work with MooseX::Types::Moose';
	my $NOTmxtmo = InnocentMooseXTypes->new;
	eval { $NOTmxtmo->foo($str) };
	like ( $@, qr/does not pass the type constraint/, "MooseX::Types object's attribute to overloaded object" );
	ok ( ! defined $NOTmxtmo->foo , "Attribute remains undefined" );
}

1;
