package Dancer2::Plugin::StoreManager;

use 5.20.0;
use warnings;

use Dancer2::Plugin;

use Dancer2::Plugin::REST;

use Module::Runtime qw/ use_module /;

use experimental 'signatures', 'postderef';

has store_class => (
    is          => 'ro',
    from_config => sub { die "plugin needs store_class to be provided\n" },
);

has db => (
    is          => 'ro',
    from_config => sub { die "plugin needs db to be provided\n" },
);

has store => (
    is => 'ro',
    lazy => 1,
    default => sub($self) {
       use_module( $self->store_class )->connect( $self->db );
    },
);

sub BUILD($self,@) {

    # TODO also take a uri namespace for the api

    $self->generate_resource_routes($_)
        for $self->store->model_classes;
}

sub generate_resource_routes($self,$model) {
    my $resource = $model->store_model;
    resource lc $resource =>
       create => sub($app) {  
           my $object = $self->store->create( 
               $resource => $app->request->data->%*
           );
           $object->store;
           $object->pack;
       },
       get    => sub($app) {
           my @id = ( $resource => $app->request->param('id') );

           return status_not_found unless $self->store->exists(@id);

           $self->store->get( @id )->pack;
       },
       delete => sub($app) {    
           $self->store->delete( 
               $resource => $app->request->param('id') 
           );
           return status_ok;
       },
       update => sub($app) {        
           my @id = ( $resource => $app->request->param('id') );

           return status_not_found unless $self->store->exists(@id);

           my $object = $self->store->get( @id );

           while( my ($attr, $value ) = each $app->request->data->%* ) {
               $object->$attr($value);
           }

           $object->store;
           $object->pack;
       };
}

1;
