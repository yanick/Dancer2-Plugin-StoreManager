package Proto;
use Dancer2;

our $VERSION = '0.1';

use Dancer2::Plugin::StoreManager;

get '/' => sub {
    template 'index';
};

true;
