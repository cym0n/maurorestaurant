package Mauro::Admin;

use Dancer2;
use Dancer2::Plugin::Strehler;
use Mauro::Element::Wine;
use Data::Dumper;

get '/wine' => sub
{
    redirect dancer_app->prefix . '/wine/list';
};

get '/wine/list' => sub
{
    my $page = exists params->{'page'} ? params->{'page'} : session 'wine-page';
    my $cat_param = exists params->{'cat'} ? params->{'cat'} : session 'wine-cat-filter';
    if(exists params->{'catname'})
    {
        my $wanted_cat = Strehler::Element::Category::explode_name(params->{'catname'});
        $cat_param = $wanted_cat->get_attr('id');
    }
    $page ||= 1;
    my $cat = undef;
    my $subcat = undef;
    ($cat, $subcat) = Strehler::Element::Category::explode_tree($cat_param);
    my $entries_per_page = 20;
    my $elements = Mauro::Element::Wine::get_list({ page => $page, entries_per_page => $entries_per_page, category_id => $cat_param});
    session 'image-page' => $page;
    session 'image-cat-filter' => $cat_param;
    print Dumper($elements->{'to_view'});
    #template "admin/image_list", { images => $elements->{'to_view'}, page => $page, cat_filter => $cat, subcat_filter => $subcat, last_page => $elements->{'last_page'} };
};

1;
