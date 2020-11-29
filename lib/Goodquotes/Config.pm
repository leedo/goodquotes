package Goodquotes::Config;

use JSON::PP;
use Class::Tiny qw(
    quotes_feed
    access_token
    access_token_secret
    consumer_key
    consumer_key_secret
), {
    poll_interval => 300,
    state_path => "./state.db",
};

sub new_from_path {
    my ($class, $path) = @_;

    open my $fh, '<', $path or die "Unable to open config: $!";
    my $conf = decode_json(join('', <$fh>));

    return $class->new(%$conf);
}

1;
