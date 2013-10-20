package Mauro;

use Dancer2;
use Data::Dumper;

set layout => 'mauro';

get '/' => sub {
    my $showcase = Strehler::Element::Image::get_list({'tag' => "showcase", 'entries_per_page' => 4});
    template "index", { images => $showcase->{'to_view'} };
};



1;
