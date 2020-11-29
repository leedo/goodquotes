package Goodquotes::Renderer;

use strict;
use warnings;

use Cairo;
use Pango;

use constant {
    PANGO_SCALE => 1024,
    CANVAS_HEIGHT => 1024,
};


use Class::Tiny {
    background   => "fff1e5",
    quote_font   => "Georgia 16",
    author_font  => "Georgia Bold 16",
    source_font  => "Georgia Italic 16",
    font_color   => "33302e",
    canvas_width => 800,
    padding      => 16,
    line_spacing => 4,
};

sub hex_to_rgb {
    my $color = shift;
    return map $_ / 255, unpack 'C*', pack 'H*', $color;
}

sub render {
    my ($self, $entry) = @_;

    my $surface = Cairo::ImageSurface->create('rgb24', $self->canvas_width, CANVAS_HEIGHT);
    my $cr = Cairo::Context->create($surface);

    $cr->rectangle(0, 0, $self->canvas_width, CANVAS_HEIGHT);
    $cr->set_source_rgb( hex_to_rgb($self->background) );
    $cr->fill;

    my $height = $self->padding;
    my $width = $self->canvas_width - ( $self->padding * 2 );

    $cr->set_source_rgb( hex_to_rgb($self->font_color) );
    $cr->move_to( $self->padding, $height);

    my $layout = Pango::Cairo::create_layout($cr);
    my $font = Pango::FontDescription->from_string($self->quote_font);
    $layout->set_font_description($font);
    $layout->set_width($width * PANGO_SCALE);
    $layout->set_wrap("word");
    $layout->set_text($entry->quote);
    $layout->set_spacing($self->line_spacing * PANGO_SCALE);

    my ($w, $h) = $layout->get_size;
    $height += ( $h / PANGO_SCALE) + $self->padding;

    Pango::Cairo::show_layout($cr, $layout);

    $cr->move_to($self->padding, $height);

    my $layout2 = Pango::Cairo::create_layout($cr);
    my $font2 = Pango::FontDescription->from_string($self->author_font);
    $layout2->set_font_description($font2);
    $layout2->set_width($width * PANGO_SCALE);
    $layout2->set_wrap("word");
    $layout2->set_text($entry->author);
    $layout2->set_spacing($self->line_spacing * PANGO_SCALE);

    my ($w2, $h2) = $layout2->get_size;
    $height += ($h2 / PANGO_SCALE) + $self->line_spacing;

    Pango::Cairo::show_layout($cr, $layout2);

    $cr->move_to($self->padding, $height);

    my $layout3 = Pango::Cairo::create_layout($cr);
    my $font3 = Pango::FontDescription->from_string($self->source_font);
    $layout3->set_font_description($font3);
    $layout3->set_width($width * PANGO_SCALE);
    $layout3->set_wrap("word");
    $layout3->set_text($entry->source_name);
    $layout3->set_spacing($self->line_spacing * PANGO_SCALE);

    my ($w3, $h3) = $layout3->get_size;
    $height += ($h3 / PANGO_SCALE) + $self->padding;

    Pango::Cairo::show_layout($cr, $layout3);

    my $surface2 = Cairo::ImageSurface->create('rgb24', $self->canvas_width, $height);
    my $cr2 = Cairo::Context->create($surface2);
    $cr2->set_source_surface($surface, 0, 0);
    $cr2->paint;

    my $png = '';
    $surface2->write_to_png_stream( sub { $png .= $_[1] });
    return $png;
}

1;
