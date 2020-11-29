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

```
cpanm -nq -l local --installdeps .
```


### Running goodquotes

```
perl -Ilib -Ilocal/lib/perl5 bin/goodquotes config.json
```
