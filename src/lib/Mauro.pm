package Mauro;

use Dancer2;
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
    template "index", { title => "Homepage", images => \@showcase };
};
get '/dove-siamo' => sub {
   template "dove-siamo", { title => "Dove siamo" }; 
};



1;
