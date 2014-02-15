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

#sub get_basic_data
#{
#    my $self = shift;
#    my %data;
#    $data{'id'} = $self->get_attr('id');
#    $data{'name'} = $self->get_attr('name');
#    $data{'title'} = $self->get_attr('name') . " " . $self->get_attr('year');
#    $data{'year'} = $self->get_attr('year');
#    $data{'region'} = $self->get_attr('region');
#    if($self->get_attr('winery') && $self->row->winery)
#    {
#        $data{'winery'} = $self->row->winery->name;
#        $data{'winery_link'} = $self->row->winery->link;
#    }
#    else
#    {
#        $data{'winery'} = '';
#    }
#    $data{'category'} = $self->row->category->category;
#    $data{'published'} = $self->get_attr('published');
#    return %data;
#}

sub winery
{
    my $self = shift;
    my %data;
    if($self->get_attr('winery') && $self->row->winery)
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
1;
