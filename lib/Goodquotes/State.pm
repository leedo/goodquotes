package Goodquotes::State;

use strict;
use warnings;

use JSON::PP;
use Class::Tiny qw(path last_pubdate);

sub load {
    my ($class, $path) = @_;
    open my $fh, '<', $path or die "unable to open state to load: $!";
    my $state = decode_json join('', <$fh>);
    return $class->new( %$state, path => $path );
}

sub save {
    my $self = shift;
    open my $fh, '>', $self->path or die "unable to open state to save: $!";
    print $fh encode_json $self->data;
}

sub data {
    my $self = shift;
    return { last_pubdate => $self->last_pubdate };
}

1;
