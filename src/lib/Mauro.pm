package Mauro;

use Dancer2;
use Data::Dumper;

set layout => 'mauro';

get '/' => sub {
    my $showcase = Strehler::Element::Image::get_list({'tag' => "showcase", 'entries_per_page' => 4});
    template "index", { title => "Homepage", images => $showcase->{'to_view'} };
};
get '/dove-siamo' => sub {
   template "dove-siamo", { title => "Dove siamo" }; 
};



1;
