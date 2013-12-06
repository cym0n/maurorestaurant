use utf8;
package Mauro::MauroDB;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-13 16:49:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bVL+9/NXcNKOvLZS0DweEA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

Mauro::MauroDB::Result::Category->has_many(
  "wines",
  "Mauro::MauroDB::Result::Wine",
  { "foreign.category" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
1;
