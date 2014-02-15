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




1;
