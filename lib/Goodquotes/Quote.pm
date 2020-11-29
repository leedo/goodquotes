package Goodquotes::Quote;

use strict;
use warnings;

use Web::Scraper;
use Class::Tiny qw(author source_url source_name quote);

my $scraper = scraper {
    process 'h1.quoteText', quote => 'TEXT';
    process 'span.authorOrTitle', author => 'TEXT';
    process 'a.authorOrTitle', source_url => '@href';
    process 'a.authorOrTitle', source_name => 'TEXT';
};

sub new_from_html {
    my ( $class, $html ) = @_;
    my $res = $scraper->scrape($html);
    $res->{author} =~ s/\s*,\s*$//;
    $res->{author} =~ s/^\s+//;
    return $class->new(%$res);
}

1;
