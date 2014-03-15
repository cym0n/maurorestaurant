package Mauro;

use Dancer2;
use Dancer2::Plugin::Multilang;
use Text::Markdown 'markdown';
use Mauro::Element::Wine;
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

    my $text = Strehler::Element::Article->get_last_by_date('pagine/homepage', language);
    my %text_data = $text->get_ext_data(language);
    my %page_title = ( it => 'Cucina tipica milanese', en => 'Typical Milanese cooking' );

    my %page_description = ( it => "Ristorante a Milano zona piazzale Susa, la tradizione della cucina tipica milanese si unisce alla modernit&agrave; e all'eleganza del locale. Il menu varia per offrire carne e pesce di prima qualit&agrave;, accompagnati dal meglio delle specialit&agrave; stagionali. Possibilit&agrave; di preventivi per cene aziendali.",
                             en => 'Restaurant in Milan where the traditional regional cooking meets the modernity and elegance of the local. Menu available in English.' );
    my $lang = language;

    template "index", { title => $page_title{$lang}, page_description => $page_description{$lang}, language => $lang, 
                        images => \@showcase, text => \%text_data };
};
get '/dove-siamo|/location' => sub 
{
    my %page_title = ( it => 'Dove siamo',
                  en => 'Location' );
    my %page_description = ( it => 'Guarda sulla mappa la posizione di Mauro Restaurant',
                             en => 'Check on the map the Mauro Restaurant location' );
    my $lang = language;

    template "dove-siamo", { title => $page_title{$lang}, page_description => $page_description{$lang}, language => language }; 
};
get '/menu' => sub 
{
  my %items;
  my %text_data;
  foreach my $cat ('antipasti', 'primi', 'secondi di carne', 'secondi di pesce', 'desserts')  
  {
    my $plates = Strehler::Element::Article->get_list({category => 'menu/'.$cat, 'entries_per_page' => -1, published => 1, ext => 1, language => language});
    my $tpltag = $cat;
    $tpltag =~ s/ //g;
    $items{$tpltag} = $plates->{'to_view'};
  }
  my $text = Strehler::Element::Article->get_last_by_date('pagine/menu', language);
  if($text)
  {
        %text_data = $text->get_ext_data(language);
        $text_data{'text'} = markdown($text_data{'text'}) if $text_data{'text'};
  }
  else
  {
        %text_data = undef;
  }
  my %page_title = ( it => 'Menu',
                     en => 'Menu' );
  my %page_description = ( it => 'Sfoglia il menu di Mauro Restaurant, aggiornato in tempo reale',
                           en => 'Browse Mauro Restaurant menu, daily updated' );
  my $lang = language;
  template "menu", { title => $page_title{$lang}, page_description => $page_description{$lang}, language => language, intro => \%text_data, %items }; 
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
  my $text = Strehler::Element::Article->get_last_by_date('pagine/business lunch', language);
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

get '/vini/vini-rossi|/wine/red-wine' => sub
{
    my %page_title = ( it => 'Vini rossi',
                       en => 'Red wine' );
    my %page_description = ( it => "Questa la selezione di vini rossi offerta da Mauro Restaurant",
                             en => "These are the red wines offered by Mauro Restaurant" );
    my $lang = language;
    my $wines = Mauro::Element::Wine->get_list({category => 'vini/vini rossi', 'entries_per_page' => -1, published => 1});
    template "wines-list", { title => $page_title{$lang}, page_description => $page_description{$lang}, wines_type => "Vini rossi", language => language, wines => $wines->{to_view} };
};
get '/vini/vini-bianchi|/wine/white-wine' => sub
{
    my %page_title = ( it => 'Vini bianchi',
                       en => 'White wine' );
    my %page_description = ( it => "Questa la selezione di vini bianchi offerta da Mauro Restaurant",
                             en => "These are the white wines offered by Mauro Restaurant" );
    my $lang = language;

    my $wines = Mauro::Element::Wine->get_list({category => 'vini/vini bianchi', 'entries_per_page' => -1, published => 1});
    template "wines-list", { title => $page_title{$lang}, page_description => $page_description{$lang}, wines_type => "Vini bianchi", language => language, wines => $wines->{to_view} };
};
get '/per-le-aziende|/for-business' => sub
{
    my %page_title = ( it => 'Per le aziende',
                       en => 'For business' );
    my %page_description = ( it => "Sei un'azienza? Mauro Restaurant ha delle opportunit&agrave; per te",
                             en => 'Do you need a place for your business meetings? Mauro Restaurant could be the place!' );
    my $lang = language;
    my $text = Strehler::Element::Article->get_last_by_date('pagine/per le aziende', language);
    my %text_data = $text->get_ext_data(language);
    $text_data{'text'} = markdown($text_data{'text'});
    template "page", { title => $page_title{$lang}, page_description => $page_description{$lang}, language => language, content => \%text_data }; 
};
get '/nostri-social|/social-networks' => sub
{
    my %page_title = ( it => 'I nostri social',
                       en => 'Social Networks' );
    my %page_description = ( it => "I social networks dove puoi trovare Mauro Restaurant",
                             en => 'Social Network where Mauro Restaurant is' );
    my $lang = language;
    template "social.tt", { title => $page_title{$lang}, page_description => $page_description{$lang}, language => $lang }; 
};


1;
