package Proto::Store::Model::Ship;

use 5.20.0;

use Moose;
use MooseX::MungeHas { has_ro => [ 'is_ro' ] };

with 'DBIx::NoSQL::Store::Manager::Model';

has_ro name => (
    traits   => [ 'StoreKey' ],
    required => 1,
);

has_ro hull   => ();
has_ro engine => ();

1;
