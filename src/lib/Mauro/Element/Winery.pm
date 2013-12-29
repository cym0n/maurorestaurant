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
    $data{'title'} = $self->main_title();
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


sub main_title
{
    my $self = shift;
    return $self->get_attr('name');
}

sub make_select
{
    my $self = shift;
    my @category_values = schema->resultset('Winery')->search();
    my @category_values_for_select;
    push @category_values_for_select, { value => undef, label => "-- seleziona --" }; 
    for(@category_values)
    {
        push @category_values_for_select, { value => $_->id, label => $_->name }
    }
    return \@category_values_for_select;
}

1;
