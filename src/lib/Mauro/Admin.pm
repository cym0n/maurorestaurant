package Mauro::Admin;

use Dancer2;
use Strehler::Dancer2::Plugin::Admin;
use Mauro::Element::Winery;

any '/winery/list' => sub
{
    my $list = Mauro::Element::Winery->get_list({ entries_per_page => -1});
    my $form = HTML::FormFu->new;
    $form->load_config_file( 'forms/myadmin/winery_fast.yml' );
    my $params_hashref = params;
    $form->process($params_hashref);
    if($form->submitted_and_valid)
    {
        my $new_winery = Mauro::Element::Winery->save_form(undef, $form);
        redirect dancer_app->prefix . '/winery/list';
    }
    template "myadmin/winery_list", { winerys => $list->{to_view}, form => $form }
};

1;
