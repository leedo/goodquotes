package Goodquotes::Quote;

use strict;
use warnings;

use URI;
use Web::Scraper;
use Class::Tiny qw(author source_url source_name quote);

my $scraper = scraper {
    process 'h1.quoteText', quote => 'TEXT';
    process 'span.authorOrTitle', author => 'TEXT';
    process 'a.authorOrTitle', source_url => '@href';
    process 'a.authorOrTitle', source_name => 'TEXT';
};

sub new_from_url {
    my ( $class, $url ) = @_;
    my $res = $scraper->scrape(URI->new($url));

    if (!$res) {
      die "error scraping quote from html";
    }

    for my $name (qw(quote author source_url source_name)) {
        if (! defined $res->{$name}) {
            die "missing $name";
        }
    }

    $res->{author} =~ s/\s*,\s*$//;
    $res->{author} =~ s/^\s+//;

    $res->{quote} =~ s/^\s*\x{201C}//;
    $res->{quote} =~ s/\x{201D}\s*$//;

    return $class->new(%$res);
}

1;
