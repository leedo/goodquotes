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
    author_color
    source_color
    canvas_width
    padding
    line_spacing
    border_color
    convert_cmd
), {
    poll_interval => 300,
    state_path => "./state.db",
};

my @twitter_opts = qw(
    access_token access_token_secret consumer_key
    consumer_key_secret
);

my @render_opts = qw(
    background quote_font author_font source_font font_color
    canvas_width padding line_spacing convert_cmd author_color
    source_color
);

sub twitter_opts {
    my $self = shift;
    map { $_ => $self->$_ } grep defined $self->$_, @twitter_opts;
}

sub render_opts {
    my $self = shift;
    map { $_ => $self->$_ } grep defined $self->$_, @render_opts;
}

sub new_from_path {
    my ($class, $path) = @_;

    open my $fh, '<', $path or die "unable to open config: $!";
    my $conf = decode_json(join('', <$fh>));

    return $class->new(%$conf);
}

1;
