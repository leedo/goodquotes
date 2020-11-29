package Goodquotes;

use strict;
use warnings;

use Goodquotes::Renderer;
use Goodquotes::Quote;

use LWP::UserAgent;
use XML::Feed;
use Twitter::API;
use Class::Tiny qw(config state), {
    ua => sub { LWP::UserAgent->new },
};

sub info;

sub run {
    my $self = shift;

    my $client = Twitter::API->new_with_traits(
        traits              => 'Enchilada',
        consumer_key        => $self->config->consumer_key,
        consumer_secret     => $self->config->consumer_key_secret,
        access_token        => $self->config->access_token,
        access_token_secret => $self->config->access_token_secret,
    );

    while (1) {
        info "polling for changes";
        my $res = $self->ua->get( $self->config->quotes_feed );

        if (!$res->is_success) {
            warn "WTF";
            info "Failed to fetch feed: %s", $res->status_line;
            goto NEXT;
        }

        my $feed = XML::Feed->parse( \($res->content) ) or do {
            info "Failed to parse feed: %s", XML::Feed->errstr;
            goto NEXT;
        };

        my $newest = my $last = $self->state->last_pubdate;

        for my $e ( $feed->entries ) {
            my $time = $e->issued->epoch;

            if ($time <= $last) {
                next;
            }

            my $res = $self->ua->get($e->link);
            if (!$res->is_success) {
                info "failed to fetch quote: %s", $res->status_line;
                goto NEXT;
            }

            info "posting %s", $e->link;

            my $entry = Goodquotes::Quote->new_from_html($res->decoded_content);
            my $image = Goodquotes::Renderer->new->render($entry);
            my $media = $client->upload([undef, "image.png", Content => $image]);
            my $post  = $client->update($e->link, {media_ids => $media->{media_id}});

            if ( $time > $newest) {
                $newest = $time;
            }
        }

        $self->state->last_pubdate($newest);
        $self->state->save;

        NEXT: sleep $self->config->poll_interval;
    }
}

sub info {
    my ( $line, @args ) = @_;
    printf "INFO [%s] $line\n", scalar(localtime), @args;
}

1;
