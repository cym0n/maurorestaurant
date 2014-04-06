package Mauro::Element::ItalianRegion;

use Moo;
use Dancer2;
use Dancer2::Plugin::DBIC;

extends 'Strehler::Element';

sub metaclass_data 
{
    my $self = shift;
    my $param = shift;
    my %element_conf = ( item_type => 'itregion',
                         ORMObj => 'ItalianRegion',
                         category_accessor => '',
                         multilang_children => '' );
    return $element_conf{$param};
}

1;
