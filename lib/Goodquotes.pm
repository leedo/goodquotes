package Goodquotes;

use strict;
use warnings;

use Goodquotes::Renderer;
use Goodquotes::Quote;
use Goodquotes::Twitter;

use XML::Feed;
use Class::Tiny qw(config state), {
  ua => sub { LWP::UserAgent->new }
};

sub info;

sub run {
    my $self = shift;

    my $twitter = Goodquotes::Twitter->new($self->config->twitter_opts);
    my $renderer = Goodquotes::Renderer->new($self->config->render_opts);

    while (1) {
        info "polling for changes";

        my $feed = XML::Feed->parse( URI->new($self->config->quotes_feed) ) or do {
            info "failed to parse feed: %s", XML::Feed->errstr;
            goto NEXT;
        };

        my @new = sort { $a->issued->epoch <=> $b->issued->epoch }
                  grep { $_->issued->epoch > $self->state->last_pubdate }
                  $feed->entries;

        for my $e (@new) {
            my $res = $self->ua->get($e->link);
            if (!$res->is_success) {
                info "failed to fetch quote: %s", $res->status_line;
                goto NEXT;
            }

            info "posting %s", $e->link;

            eval {
                my $entry = Goodquotes::Quote->new_from_html($res->decoded_content);
                my $image = $renderer->render($entry);
                $twitter->post($e->link, $image);
            };

            if (my $err = $@) {
                info "aborted %s due to error: %s", $e->link, $err;
                goto NEXT;
            }

            $self->state->last_pubdate($e->issued->epoch);
            $self->state->save;
        }

        NEXT: sleep $self->config->poll_interval;
    }
}

sub info {
    my ( $line, @args ) = @_;
    printf "INFO [%s] $line\n", scalar(localtime), @args;
}

1;
