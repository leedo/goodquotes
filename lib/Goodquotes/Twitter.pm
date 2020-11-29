package Goodquotes::Twitter;

use Twitter::API;
use Class::Tiny qw(
    access_token
    access_token_secret
    consumer_key
    consumer_key_secret
);

sub post {
  my ( $self, $text, $image ) = @_;

  my $client = Twitter::API->new_with_traits(
    traits              => 'Enchilada',
    consumer_key        => $self->consumer_key,
    consumer_secret     => $self->consumer_key_secret,
    access_token        => $self->access_token,
    access_token_secret => $self->access_token_secret,
  );

  my $media = $client->upload([undef, "image.png", Content => $image]);
  my $post  = $client->update($text, {media_ids => $media->{media_id}});
}

1;
