package Types;
use MooseX::Types;
use MooseX::Types::Moose qw/Str Object/;
use Sub::Exporter -setup => { exports => [qw/Str/] };

coerce Str , from Object , via { die "Object Received" };

package Class;
use Moose;
BEGIN { Types->import( 'Str' ) };

has 'foo' => ( isa => Str, is => 'rw' , coerce => 1);

my $c = Class->new;
$c->foo( "foo" );
$c->foo( $c );


