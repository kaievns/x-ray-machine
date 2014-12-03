# X Ray Machine

![X-Ray](./x-ray.jpg)

Ever wanted to log and profile your external API calls in a Rails app the
same way Rails does with active record? Look no further, as the `x-ray-machine`
is the thing that will enable you to do that!

## Usage

As per usual add this to your `Gemfile`

```ruby
gem 'x-ray-machine'
```

Then just call `XRay.whatevers` with some marker you wanna see in the logs
(it can be an url or anything stringy) and then give it a block to measure.

```ruby
class MyThing
  def talk_to_elastic_search
    url = figure_the_url

    XRay.elastic_search url do
      make_the_actual_request url
    end
  end

  def talk_to_twitter_api
    XRay.twitter "loading recent tweets" do
      load_some_tweets_for_fun_and_profit
    end
  end

  def craaaazy_stuff
    XRay.baaacooon "fat acids hitting the brain" do
      i_wonder_if_spacemen_eat_bacon
    end
  end
end
```

This will show something like this in your rails console

```log
ElasticSearch (5.1ms)  /url?bla=bla&bla
Twitter (100.2ms) loading recent tweets
Baaacooon (10.1ms) fat acids hitting the brain
```

## Marking Cached Results

In case you want to mark a query as cached, you can use the `ray`
object that is passed down the block, and mark it as cached

```ruby
url = "some/url.thing"

XRay.heavy_request url do |ray|
  if result = find_in_cache(url)
    ray.cached = true
  else
    result = make_the_actual_request(url)
  end
end
```

After that your log entry will look like so

```log
HeavyRequest CACHE (0.1ms)  /url?bla=bla&bla
```


## Customization & Configuration

Normally, the `XRay` object will use `method_missing` and automatically
guess the name for the entry and use a random color for it, but you can
customize things

```ruby
XRayMachine.config do |config|
  config.elastic_search = {
    color: :yellow,         # color for the line
    title: "ES",            # title for the entries
    show_in_summary: false  # show/hide the results in the summary
  }
end
```

__NOTE__: the name you use with the `config` should match the one
that you use on the `XRay` class to track your queries.


## Copyright & License

All code in this repository is released under the terms of the MIT License

Copyright (C) 2014 Nikolay Nemshilov
