use utf8;
package Mauro::MauroDB::Result::ItalianRegion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mauro::MauroDB::Result::ItalianRegion

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

=head1 TABLE: C<ITALIAN_REGIONS>

=cut

__PACKAGE__->table("ITALIAN_REGIONS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 display_order

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "display_order",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 wines

Type: has_many

Related object: L<Mauro::MauroDB::Result::Wine>

=cut

__PACKAGE__->has_many(
  "wines",
  "Mauro::MauroDB::Result::Wine",
  { "foreign.italian_region" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-04-06 16:29:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LHrOrXFD0InOBBfmT0toUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
