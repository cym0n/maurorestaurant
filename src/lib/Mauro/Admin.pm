package Mauro::Admin;

use Dancer2;
use Dancer2::Plugin::Strehler;
use Strehler::Admin;
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
        my $wanted_cat = Strehler::Meta::Category::explode_name(params->{'catname'});
        $cat_param = $wanted_cat->get_attr('id');
    }
    $page ||= 1;
    my $cat = undef;
    my $subcat = undef;
    ($cat, $subcat) = Strehler::Meta::Category::explode_tree($cat_param);
    my $entries_per_page = 20;
    my $elements = Mauro::Element::Wine->get_list({ page => $page, entries_per_page => $entries_per_page, category_id => $cat_param});
    session 'wine-page' => $page;
    session 'wine-cat-filter' => $cat_param;
    template "myadmin/wine_list", { wines => $elements->{'to_view'}, page => $page, cat_filter => $cat, subcat_filter => $subcat, last_page => $elements->{'last_page'} };
};
get '/wine/delete/:id' => sub
{
    my $id = params->{id};
    my $art = Mauro::Element::Wine->new($id);
    my %article = $art->get_basic_data();
    template "admin/delete", { what => "il vino", el => \%article, , backlink => dancer_app->prefix . '/article' };
};
post '/wine/delete/:id' => sub
{
    my $id = params->{id};
    my $article = Mauro::Element::Wine->new($id);
    $article->delete();
    redirect dancer_app->prefix . '/wine/list';
};
get '/wine/turnon/:id' => sub
{
    my $id = params->{id};
    my $article = Mauro::Element::Wine->new($id);
    $article->publish();
    redirect dancer_app->prefix . '/wine/list';
};
get '/wine/turnoff/:id' => sub
{
    my $id = params->{id};
    my $article = Mauro::Element::Wine->new($id);
    $article->unpublish();
    redirect dancer_app->prefix . '/wine/list';
};
any '/wine/add' => sub
{
    my $form = form_wine(); 
    my $params_hashref = params;
    $form = Strehler::Admin::tags_for_form($form, $params_hashref);
    $form->process($params_hashref);
    if($form->submitted_and_valid)
    {
        Mauro::Element::Wine::save_form(undef, $form);
        redirect dancer_app->prefix . '/article/list';
    }
    my $fake_tags = $form->get_element({ name => 'tags'});
    $form->remove_element($fake_tags) if($fake_tags);
    template "myadmin/wine", { form => $form->render() }
};



sub form_wine
{
    my $action = shift;
    my $has_sub = shift;
    my $form = HTML::FormFu->new;
    $form->load_config_file( 'forms/myadmin/wine.yml' );
    my $category = $form->get_element({ name => 'category'});
    $category->options(Strehler::Meta::Category::make_select());
    my $subcategory = $form->get_element({ name => 'subcategory'});
    $subcategory->options(Strehler::Meta::Category::make_select($has_sub));
    return $form;
}

1;
