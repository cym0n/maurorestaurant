package Mauro::Element::Winery;

use Moo;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Data::Dumper;

extends 'Strehler::Element';


sub BUILDARGS {
   my ( $class, @args ) = @_;
   my $id = shift @args; 
   my $wine;
   if(! $id)
   {
        $wine = undef;
   }
   else
   {
        $wine = schema->resultset('Winery')->find($id);
   }
   return { row => $wine };
};

#Category accessor used by static methods
sub category_accessor
{
    return undef;
}

sub item_type
{
    return "winery";
}
sub multilang_children
{
    return "no-children";
}

sub ORMObj
{
    return "Winery";
}
sub get_basic_data
{
    my $self = shift;
    my %data;
    $data{'id'} = $self->get_attr('id');
    $data{'name'} = $self->get_attr('name');
    $data{'link'} = $self->get_attr('link');
    return %data;
}
sub get_ext_data
{
    my $self = shift;
    return $self->get_basic_data();
}

sub save_form
{
    my $self = shift;
    my $id = shift;
    my $form = shift;
    my $winery_row;
    my $winery_data = { name => $form->param_value('name'), link => $form->param_value('link')};
    if($id)
    {
        $winery_row = schema->resultset('Winery')->find($id);
        $winery_row->update($winery_data);

    }
    else
    {
        $winery_row = schema->resultset('Winery')->create($winery_data);
    }
    return $winery_row->id;  
}


#
sub get_form_data
{
    my $self = shift;
    my $wine_row = $self->row;
    my $data;
    if($wine_row->category->parent_category)
    {
        $data->{'category'} = $wine_row->category->parent_category->id;
        $data->{'subcategory'} = $wine_row->category->id;
    }
    else
    {
       $data->{'category'} = $wine_row->category->id;
    }
    $data->{'name'} = $wine_row->name;
    $data->{'year'} = $wine_row->year;
    $data->{'region'} = $wine_row->region;
    $data->{'winery'} = $wine_row->winery;
    $data->{'tags'} = Strehler::Meta::Tag::tags_to_string($self->get_attr('id'), 'wine');
    return $data;
}
sub main_title
{
    my $self = shift;
    return $self->get_attr('name');
}

1;
