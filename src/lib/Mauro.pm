package Mauro;

use Dancer2;

set layout => 'mauro';

get '/' => sub {
    template "index";
};



1;
