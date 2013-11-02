package Mauro;

use Dancer2;
use Dancer2::Plugin::Multilang;
use Data::Dumper;

set layout => 'mauro';

get '/' => sub {
    my @plate_index;
    my @restaurant_index;
    my $restaurant_images = Strehler::Element::Image::get_list({category => 'ristorante', tag => "showcase", 'entries_per_page' => -1});
    my $plates_images = Strehler::Element::Image::get_list({category => 'piatti', tag => "showcase", 'entries_per_page' => -1});
    my @restaurant = @{$restaurant_images->{'to_view'}};
    my @plates = @{$plates_images->{'to_view'}};
    my $choose_index = 0;
    while($choose_index < 2)
    {
        my $rand =  int(rand($#plates + 1));
        if($choose_index == 0)
        {
            $plate_index[0] = $rand;
            $choose_index++;
        }
        elsif($choose_index == 1 && $rand != $plate_index[0])
        {
            $plate_index[1] = $rand;
            $choose_index++;
        }
    }
    $choose_index = 0;
    while($choose_index < 2)
    {
        my $rand =  int(rand($#restaurant + 1));
        if($choose_index == 0)
        {
            $restaurant_index[0] = $rand;
            $choose_index++;
        }
        elsif($choose_index == 1 && $rand != $restaurant_index[0])
        {
            $restaurant_index[1] = $rand;
            $choose_index++;
        }
    }
    my @showcase;
    push @showcase, $plates[$plate_index[0]];
    push @showcase, $restaurant[$restaurant_index[0]];
    push @showcase, $restaurant[$restaurant_index[1]];
    push @showcase, $plates[$plate_index[1]];

    my $text = Strehler::Element::Article::get_last_by_date('homepage');
    my %text_data = $text->get_ext_data(language);
    template "index", { title => "Homepage", language => language, images => \@showcase, text => \%text_data };
};
get '/dove-siamo|/location' => sub 
{
  template "dove-siamo", { title => "Dove siamo", language => language }; 
};
get '/menu' => sub 
{
  my %items;
  foreach my $cat ('antipasti', 'secondi di carne')#, 'primi', 'secondi di carne', 'secondi di pesce', 'desserts')  
  {
    my $plates = Strehler::Element::Article::get_list({category => $cat, 'entries_per_page' => -1});
    my $tpltag = $cat;
    $tpltag =~ s/ //g;
    $items{$tpltag} = $plates->{'to_view'};
  }
  template "menu", { title => "Menu", language => language, %items }; 
};



1;
