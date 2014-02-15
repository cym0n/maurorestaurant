use utf8;
package Mauro::MauroDB::Result::Wine;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mauro::MauroDB::Result::Wine

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

=head1 TABLE: C<WINES>

=cut

__PACKAGE__->table("WINES");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 year

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 winery

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 category

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 published

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "year",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "winery",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "category",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "published",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Mauro::MauroDB::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Mauro::MauroDB::Result::Category",
  { id => "category" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 winery

Type: belongs_to

Related object: L<Mauro::MauroDB::Result::Winery>

=cut

__PACKAGE__->belongs_to(
  "winery",
  "Mauro::MauroDB::Result::Winery",
  { id => "winery" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07037 @ 2014-02-15 12:23:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P2NuiqpRIA61pDvDlhPu2g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
