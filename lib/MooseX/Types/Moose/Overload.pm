package MooseX::Types::Moose::Overload;
use 5.010;

use base 'MooseX::Types::Moose';

use mro 'c3';
use overload;

our $VERSION = '0.01_02';

## {
## 	Str => :ltrim, :rtrim:, :trim, :multispace
## 	Bool => :string  y/n t/f
## }

sub _unOverload {
	overload::Overloaded( $_[0] ) && overload::Method( $_[0], '""' )
	? "$_[0]"
	: $_[0]
}

for my $name ( Moose::Util::TypeConstraints->list_all_builtin_type_constraints ) {
	my $constraint = Moose::Util::TypeConstraints::find_type_constraint( $name );

	if ( $constraint->is_subtype_of( 'Value' ) ) {
		Moose::Util::TypeConstraints::_install_type_coercions(
			$name
			, [ Object => \&_unOverload ] ## From any overloaded objects
		);
	}

}

no MooseX::Types;
no overload;

1;

__END__

=head1 NAME

MooseX::Types::Moose::Overload - Deal with overload, in the overloaded sense ;)

=head1 DESCRIPTION

This module subclasses MooseX::Types::Moose with an ability to transparently handle L<overload>ed objects. All you have to do is use it, and then add C<coerce =E<gt> 1> to the attributes you wish to enable it on. It will then stringify all objects that support the stringifiy method. This works in the style of overload, forcing Moose to just do you want. Something that stringifies to a string should simply work when the attribute isa Str, right‽ Good, thought so.

This modifies the base types in a slightly ugly way and has little to nothing to do with MooseX types. I reserve the right to remove it from cpan, or change its namespace until it is removed from DEV status; because the base types are global, this attaches to B<all> modules that use the base types.

This only attaches a coercion to subtypes of "Value", and it only coerces from "Objects", and only executes on Objects that stringify overload.

=head1 SYNOPSIS

	use MooseX::Types::Moose::Overload;

	## Now takes a URI object, or HTTP::Element, and of course a plain string.
	has 'uri' => ( isa => 'Str', is => 'rw', coerce => 1 );

=head1 TODO

These aren't set in stone:

=over 6

=item

Provide an overload for 'has' that simply works.

=item

Look at ammending other flaws in the base types -- for instance, Bool should accept true/false, t/f, yes/no, y/n. And, strings should provide an easy way to be made pretty. This module might evolve into MooseX::Types::PragmaticBaseTypes.

=back

=head1 AUTHOR

Evan Carroll, C<< <me at evancarroll.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-types-overload at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Types-Moose-Overload>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Types::Overload


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Types-Overload>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Types-Overload>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Types-Overload>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Types-Overload/>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Evan Carroll, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut