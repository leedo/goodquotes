# Goodquotes

This program monitors Goodreads for new quotes, and reposts them to Twitter as an embedded image. This is useful because Kindle devices can only share quotes to Goodreads. This tool allows you to indirectly share Kindle quotes to Twitter.

A sample image generated from a Goodreads quote:

<img src="https://prettybrd.com/~leedo/b/out7.png" width=600>

## Setup

### Create `config.json`

There must be a `config.json` that contains the following keys:

 * `access_token` - Twitter API access token
 * `access_token_secret` - Twitter API access token secret
 * `consumer_key` - Twitter API consumer key
 * `consumer_key_secret` - Twitter API consumer key secret
 * `quotes_feed` - Goodreads quotes RSS feed

You can find the quotes RSS feed by visiting your quotes page, and
copying the RSS link at the bottom of the page.

### Installing dependencies

Libaries and tools

```
sudo apt-get install libcairo2-dev libpango1.0-dev inkscape cpanminus
```

Perl dependencies

```
cpanm -nq -l local --installdeps .
```

### Running on Mac

To run this on mac you must install `inkscape`. It is easiest to install this with `brew install inkscape`. With newer versions of Inkscape you must add `convert_cmd` to `config.json`.

```
{
  ...
  "convert_cmd": ["inkscape", "-p", "-o", "-", "--export-type", "png", "-d", "300"]
}
```

### Running goodquotes

```
perl -Ilib -Ilocal/lib/perl5 bin/goodquotes config.json
```

### Configuring image style

The following styling options can be set in `config.json`:

  * `background` - background color (default: `fff1e5`)
  * `quote_font` - font used for quote (default: `Georgia 16`)
  * `author_font` - font used for author name (default: `Georgia Bold 12`)
  * `source_font` - font used for source name (default: `Georgia Italic 12`)
  * `font_color` - font color used for all text (default: `33302e`)
  * `border_color` - color used for line separator (default: `ccc1b7`)
  * `canvas_width` - image width (default: `800`)
  * `padding` - padding size (default: `16`)
  * `line_spacing` - space between lines (default: `4`)
