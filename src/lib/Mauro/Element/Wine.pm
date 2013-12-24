package Mauro::Element::Wine;

use Moo;
use Dancer2;
use Dancer2::Plugin::DBIC;

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
        $wine = schema->resultset('Wine')->find($id);
   }
   return { row => $wine };
};

#Category accessor used by static methods
sub category_accessor
{
    my $self = shift;
    my $category = shift;
    return $category->can('wines');
}

sub item_type
{
    return "wine";
}
sub multilang_children
{
    return "no-children";
}

sub ORMObj
{
    return "Wine";
}
sub get_basic_data
{
    my $self = shift;
    my %data;
    $data{'id'} = $self->get_attr('id');
    $data{'name'} = $self->get_attr('name');
    $data{'title'} = $self->get_attr('name') . " " . $self->get_attr('year');
    $data{'year'} = $self->get_attr('year');
    $data{'region'} = $self->get_attr('region');
    if($self->get_attr('winery') && $self->row->winery_ref)
    {
        $data{'winery'} = $self->row->winery_ref->name;
        $data{'winery_link'} = $self->row->winery_ref->link;
    }
    else
    {
        $data{'winery'} = '';
    }
    $data{'category'} = $self->row->category->category;
    $data{'published'} = $self->get_attr('published');
    return %data;
}
sub get_ext_data
{
    my $self = shift;
    return $self->get_basic_data();
}
sub publish
{
    my $self = shift;
    $self->row->published(1);
    $self->row->update();
}
sub unpublish
{
    my $self = shift;
    $self->row->published(0);
    $self->row->update();
}

sub save_form
{
    my $id = shift;
    my $form = shift;
    
    my $wine_row;
    my $category = undef;
    if($form->param_value('subcategory'))
    {
        $category = $form->param_value('subcategory');
    }
    elsif($form->param_value('category'))
    {
        $category = $form->param_value('category');
    }
    my $wine_data ={ name => $form->param_value('name'), year => $form->param_value('year'), region => $form->param_value('region'), winery => $form->param_value('winery'), category => $category};
    if($id)
    {
        $wine_row = schema->resultset('Wine')->find($id);
        $wine_row->update($wine_data);

    }
    else
    {
        $wine_row = schema->resultset('Wine')->create($wine_data);
    }
    if($form->param_value('tags'))
    {
        Strehler::Meta::Tag::save_tags($form->param_value('tags'), $wine_row->id, 'wine');
    }
    return $wine_row->id;  
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
