# Goodquotes

This program monitors Goodreads for new quotes, and reposts them to Twitter as an embedded image. This is useful because Kindle devices can only share quotes to Goodreads. This tool allows you to indirectly share Kindle quotes to Twitter.

A sample image generated from a Goodreads quote:

<img src="https://prettybrd.com/~leedo/b/out6.png" width=600>

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
sudo apt-get install libcairo2-dev libpango1.0-dev inkscape
```

Perl dependencies

```
cpanm -nq -l local --installdeps .
```


### Running goodquotes

```
perl -Ilib -Ilocal/lib/perl5 bin/goodquotes config.json
```
