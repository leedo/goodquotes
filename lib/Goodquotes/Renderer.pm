package Goodquotes::Renderer;

use strict;
use warnings;

use Cairo;
use Pango;

use constant PANGO_SCALE => 1024;

use Class::Tiny {
    background => "#ffffff",
    font_size  => 16,
    font_file  => "./Georgia.ttf",
    font_color => "#000000",
    padding    => 16,
};
    
sub render {
    my ($self, $entry) = @_;

    my $surface = Cairo::ImageSurface->create('argb32', 800, 800);
    my $cr = Cairo::Context->create($surface);

    $cr->rectangle(0, 0, 800, 800);
    $cr->set_source_rgb(255/255, 241/255, 229/255);
    $cr->fill;

    my $height = $self->padding;
    my $width = 800 - ( $self->padding * 2 );

    $cr->set_source_rgb(51/255, 48/255, 0/255);
    $cr->move_to( $self->padding, $height);

    my $layout = Pango::Cairo::create_layout($cr);
    my $font = Pango::FontDescription->from_string('Georgia 16');
    $layout->set_font_description($font);
    $layout->set_width($width * PANGO_SCALE);
    $layout->set_wrap("word");
    $layout->set_text($entry->quote);
    $layout->set_spacing(4 * PANGO_SCALE);

    my ($w, $h) = $layout->get_size;
    $height += ( $h / PANGO_SCALE) + $self->padding;

    Pango::Cairo::show_layout($cr, $layout);

    $cr->move_to($self->padding, $height);

    my $layout2 = Pango::Cairo::create_layout($cr);
    my $font2 = Pango::FontDescription->from_string('Georgia Bold 16');
    $layout2->set_font_description($font2);
    $layout2->set_width($width * PANGO_SCALE);
    $layout2->set_wrap("word");
    $layout2->set_text($entry->author);
    $layout2->set_spacing(4 * PANGO_SCALE);

    my ($w2, $h2) = $layout2->get_size;
    $height += ($h2 / PANGO_SCALE) + 4;

    Pango::Cairo::show_layout($cr, $layout2);

    $cr->move_to($self->padding, $height);

    my $layout3 = Pango::Cairo::create_layout($cr);
    my $font3 = Pango::FontDescription->from_string('Georgia Italic 16');
    $layout3->set_font_description($font3);
    $layout3->set_width($width * PANGO_SCALE);
    $layout3->set_wrap("word");
    $layout3->set_text($entry->source_name);
    $layout3->set_spacing(4 * PANGO_SCALE);

    my ($w3, $h3) = $layout2->get_size;
    $height += ($h3 / PANGO_SCALE) + $self->padding;

    Pango::Cairo::show_layout($cr, $layout3);

    my $surface2 = Cairo::ImageSurface->create('argb32', 800, $height);
    my $cr2 = Cairo::Context->create($surface2);
    $cr2->set_source_surface($surface, 0, 0);
    $cr2->paint;

    my $png = '';
    $surface2->write_to_png_stream( sub {
        $png .= $_[1];
    });
    return $png;
}

1;
