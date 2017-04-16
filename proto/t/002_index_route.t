use strict;
use warnings;

use Proto;
use Test::More tests => 2;
use Test::WWW::Mechanize::PSGI;
use JSON qw/ to_json from_json /;
use HTTP::Request::Common;

my $test = Test::WWW::Mechanize::PSGI->new( app => Proto->to_app );

$test->request(( POST '/player',  
    'Content-Type' => 'application/json',
    content=> to_json( {
    name     => 'yenzie',
    alliance => 'Fearsome Federation of Furious Furries',
})), 'create player' );

$test->get_ok( '/player/yenzie', 'retrieve player' );

is_deeply from_json( $test->content ) => {
    name     => 'yenzie',
    alliance => 'Fearsome Federation of Furious Furries',
    '__CLASS__' => 'Proto::Store::Model::Player',
};

