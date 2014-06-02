package Mauro::Element::Wine;

use Moo;
use Dancer2;
use Dancer2::Plugin::DBIC;

extends 'Strehler::Element';

sub metaclass_data 
{
    my $self = shift;
    my $param = shift;
    my %element_conf = ( item_type => 'wine',
                         ORMObj => 'Wine',
                         category_accessor => 'wines',
                         multilang_children => '' );
    return $element_conf{$param};
}

sub winery
{
    my $self = shift;
    my %data;
    if($self->row->winery)
    {
        $data{'name'} = $self->row->winery->name;
        $data{'link'} = $self->row->winery->link;
    }
    else
    {
        $data{'name'} = '';
    }
    return \%data;
}

sub region
{
    my $self = shift;
    if($self->row->italian_region)
    {
        return $self->row->italian_region->name;
    }
    else
    {
        return $self->row->region;
    }
}
1;
