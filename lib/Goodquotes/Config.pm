package Goodquotes::Config;

use strict;
use warnings;

use JSON::PP;
use Class::Tiny qw(
    quotes_feed
    access_token
    access_token_secret
    consumer_key
    consumer_key_secret
    background
    quote_font
    author_font
    source_font
    font_color
    canvas_width
    padding
    line_spacing
), {
    poll_interval => 300,
    state_path => "./state.db",
};

sub render_opts {
    my $self = shift;
    return map { $_ => $self->$_ } grep defined $self->$_, qw(background quote_font author_font source_font font_color canvas_width padding line_spacing);
}

sub new_from_path {
    my ($class, $path) = @_;

    open my $fh, '<', $path or die "Unable to open config: $!";
    my $conf = decode_json(join('', <$fh>));

    return $class->new(%$conf);
}

1;
