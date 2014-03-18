package Mauro::Element::Winery;

use Moo;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Data::Dumper;

extends 'Strehler::Element';

sub metaclass_data 
{
    my $self = shift;
    my $param = shift;
    my %element_conf = ( item_type => 'winery',
                         ORMObj => 'Winery',
                         category_accessor => '',
                         multilang_children => '' );
    return $element_conf{$param};
}

sub make_select
{
    my $self = shift;
    my $list = $self->get_list( { 'order_by' => 'name', order => 'asc'} );
    my @category_values_for_select;
    push @category_values_for_select, { value => undef, label => "-- seleziona --" }; 
    for(@{$list->{to_view}})
    {
        push @category_values_for_select, { value => $_->{'id'}, label => $_->{'title'} }
    }
    return \@category_values_for_select;
}


1;
