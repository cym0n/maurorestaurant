use utf8;
package Mauro::MauroDB::Result::ConfiguredTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mauro::MauroDB::Result::ConfiguredTag

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<CONFIGURED_TAGS>

=cut

__PACKAGE__->table("CONFIGURED_TAGS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tag

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 category_id

  data_type: 'integer'
  is_nullable: 1

=head2 item_type

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 default_tag

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tag",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "category_id",
  { data_type => "integer", is_nullable => 1 },
  "item_type",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "default_tag",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07037 @ 2013-11-16 14:55:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TDyGJDQPatdFI79VyDIXfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
