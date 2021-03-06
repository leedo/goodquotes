# Goodquotes

Goodquotes monitors Goodreads for new quotes, and reposts them to Twitter as an embedded image. This is useful because Kindle devices can not share directly to Twitter, but they can share to Goodreads. With Goodquotes, you can indirectly share quotes to Twitter, with no extra work.

A sample image generated from a Goodreads quote:

<img src="https://prettybrd.com/~leedo/b/out11.png" width=500>

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

Debian and Ubuntu

```
sudo apt-get install libcairo2-dev libpango1.0-dev inkscape cpanminus
```

Mac

```
brew install cairo pango inkscape cpanminus
```

Perl dependencies

```
cpanm -nq -l local --installdeps .
```

### Running goodquotes

```
perl -Ilib -Ilocal/lib/perl5 bin/goodquotes config.json
```

### Running on Mac

With newer versions of Inkscape, such as the version installed by
Homebrew, you must add `convert_cmd` to `config.json`.

```
{
  ...
  "convert_cmd": ["inkscape", "-p", "-o", "-", "--export-type", "png", "-d", "300"]
}
```

### Configuring image style

The following styling options can be set in `config.json`:

  * `background` - background color (default: `#fff1e5`)
  * `quote_font` - font used for quote (default: `Georgia 14`)
  * `author_font` - font used for author name (default: `Arial Narrow Bold 12`)
  * `source_font` - font used for source name (default: `Arial Narrow 12`)
  * `font_color` - font color used for quote text (default: `#33302e`)
  * `author_color` - font color used for author text (default: `#990f3d`)
  * `source_color` - font color used for source text (default: `#66605c`)
  * `border_color` - color used for line separator (default: `#ccc1b7`)
  * `canvas_width` - image width (default: `500`)
  * `padding` - padding size (default: `16`)
  * `line_spacing` - space between lines (default: `4`)
