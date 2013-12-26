package Mauro;

use Dancer2;
use Dancer2::Plugin::Multilang;
use Text::Markdown 'markdown';
use Data::Dumper;

set layout => 'mauro';

hook before_template_render => sub {
        my $tokens = shift;
        $tokens->{'google_monitor'} = config->{'google_monitor'};
};

get '/' => sub {
    my @plate_index;
    my @restaurant_index;
    my $restaurant_images = Strehler::Element::Image->get_list({category => 'ristorante', tag => "showcase", 'entries_per_page' => -1});
    my $plates_images = Strehler::Element::Image->get_list({category => 'piatti', tag => "showcase", 'entries_per_page' => -1});
    my @restaurant = @{$restaurant_images->{'to_view'}};
    my @plates = @{$plates_images->{'to_view'}};
    my $choose_index = 0;
    my @output;
    while($choose_index < 2)
    {
        my $rand =  int(rand($#plates + 1));
        push @output, splice(@plates, $rand, 1);
        $choose_index++;
    }
    $choose_index = 0;
    while($choose_index < 2)
    {
        my $rand =  int(rand($#restaurant + 1));
        push @output, splice(@restaurant, $rand, 1);
        $choose_index++;
    }
    my @showcase;
    push @showcase, $output[0];
    push @showcase, $output[2];
    push @showcase, $output[3];
    push @showcase, $output[1];

    my $text = Strehler::Element::Article->get_last_by_date('homepage');
    my %text_data = $text->get_ext_data(language);
    if($text_data{'text'})
    {
        $text_data{'text'} = markdown($text_data{'text'});
    }

    my %page_description = ( it => 'Mauro Restaurant, ristorante a Milano, cucina tipica milanese con prodotti di stagione',
                             en => 'Mauro Restaurant, restaurant in Milan, traditional seasonal cooking' );
    my $lang = language;

    template "index", { title => "Homepage", page_description => $page_description{$lang}, language => $lang, 
                        images => \@showcase, text => \%text_data };
};
get '/dove-siamo|/location' => sub 
{
    my %page_description = ( it => 'Guarda sulla mappa la posizione di Mauro Restaurant',
                             en => 'Check on the map the Mauro Restaurant location' );
    my $lang = language;

    template "dove-siamo", { title => "Dove siamo", page_description => $page_description{$lang}, language => language }; 
};
get '/menu' => sub 
{
  my %items;
  foreach my $cat ('antipasti', 'primi', 'secondi di carne', 'secondi di pesce', 'desserts')  
  {
    my $plates = Strehler::Element::Article->get_list({category => 'menu/'.$cat, 'entries_per_page' => -1, published => 1, ext => 1});
    my $tpltag = $cat;
    $tpltag =~ s/ //g;
    $items{$tpltag} = $plates->{'to_view'};
  }
  template "menu", { title => "Menu", page_description => "Sfoglia il menu di Mauro Restaurant, aggiornato in tempo reale", language => language, %items }; 
};

get '/menu/:slug' => sub
{
    my $slug = params->{slug};
    my $recipe = Strehler::Element::Article->get_by_slug($slug, language);
    if(! $recipe || ! $recipe->exists())
    {
        send_error("Capitolo inesistente", 404);
        return;
    }
    my $cat = $recipe->get_attr('category');
    my $recipe_category = Strehler::Meta::Category->new($cat);
    my $recipe_category_parent = Strehler::Meta::Category->new($recipe_category->get_attr('parent'));
    if($recipe_category_parent->get_attr('category') ne 'menu')
    {
        send_error("Capitolo inesistente", 404);
        return;
    }
    else
    {
        my %recipe_data = $recipe->get_ext_data(language);
        $recipe_data{'text'} = markdown($recipe_data{'text'});
        template "recipe", { htmlid => 'recipe', title => $recipe_data{'title'}, page_description => 'Uno dei piatti del Mauro Restaurant', canonical => "http:/www.maurorestaurant.it/menu/" . $recipe_data{'slug'}, language => language,
                             recipe => \%recipe_data };
    } 
};


get '/business-lunch' => sub
{
  my $text = Strehler::Element::Article->get_last_by_date('business lunch');
  my %text_data = $text->get_ext_data(language);
  $text_data{'text'} = markdown($text_data{'text'});
  my %items;
  foreach my $cat ('antipasti', 'primi', 'secondi di carne', 'secondi di pesce', 'contorni')  
  {
    my $plates = Strehler::Element::Article->get_list({category => 'menu/'. $cat, tag => 'business', 'entries_per_page' => -1, published => 1});
    my $plates_only_bus = Strehler::Element::Article->get_list({category => 'businessmenu/'. $cat, 'entries_per_page' => -1, published => 1});
    my @elements = (@{$plates->{'to_view'}}, @{$plates_only_bus->{'to_view'}});
    my $tpltag = $cat;
    $tpltag =~ s/ //g;
    $items{$tpltag} = \@elements
  }
  my @main = (@{$items{'secondidicarne'}}, @{$items{'secondidipesce'}});
  $items{'secondi'} = \@main;    
  template "business-lunch", { title => "Business Lunch", page_description => "Approfitta a mezzogiorno dell'offerta Business Lunch, per provare i piatti del ristorante", language => language, claim => \%text_data, %items }; 
};

get '/vini/vini-rossi' => sub
{
    my $wines = Mauro::Element::Wine->get_list({category => 'vini/vini rossi', 'entries_per_page' => -1, published => 1});
    template "wines-list", { wines_type => "Vini rossi", language => language, wines => $wines->{to_view} };
};
get '/vini/vini-bianchi' => sub
{
    my $wines = Mauro::Element::Wine->get_list({category => 'vini/vini bianchi', 'entries_per_page' => -1, published => 1});
    template "wines-list", { wines_type => "Vini rossi", language => language, wines => $wines->{to_view} };
};
get '/personale|/crew' => sub
{
    my $crew = Strehler::Element::Article->get_list({category => 'personale/', 'entries_per_page' => -1, published => 1, order_by => 'display_order', ext => 1, language => language});
    template "crew", { language => language, crew => $crew->{to_view} };
};


1;
