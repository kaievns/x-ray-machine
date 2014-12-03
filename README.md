# X Ray Machine

When you need to see what's going on the inside of your Rails app. This project
is a simple to use wrapper around the Rails instrumentation utilities.

You mainly need this to log and profile the speed of communication to external
resources, similarly to how Rails logs database queries with ActiveRecord.

```ruby
class MyThing
  def talk_to_elastic_search
    url = figure_the_url

    XRay.elasticsearch url do
      make_the_actual_request url
    end
  end

  def talk_to_twitter_api
    XRay.twitter "loading recent tweets" do
      load_some_tweets_for_fun_and_profit
    end
  end
end
```

This will show something like this in your rails console

```log
Elasticsearch (5.1ms)  /url?bla=bla&bla
Twitter (100.2ms) loading recent tweets
```

## Marking Cached Results

In case you want to mark your query as cached, you can use the `ray`
object that is passed down the block, and mark it as cached

```ruby
url = figure_the_url

XRay.elasticsearch url do |ray|
  if result = find_in_cache(url)
    ray.cached = true
  else
    result = make_the_actual_request(url)
  end
end
```

After that your log entry will look like so

```log
Elasticsearch CACHE (5ms)  /url?bla=bla&bla
```


## Customization & Configuration

Normally, the `XRay` object will use `method_missing` and automatically
guess the name for the entry and use a random color for it, but you can
customize things

```ruby
XRayMachine.config do |config|
  config.elasticsearch = {
    color: :yellow,         # color for the line
    title: "ElasticSearch", # title for the entries
    show_in_summary: false  # show/hide the results in the summary
  }
end
```

__NOTE__: the name use with the `config` should match the one that
you use on the `XRay` class to track your queries.


## Copyright & License

All code in this repository is licensed under the terms of the MIT License

Copyright (C) 2014 Nikolay Nemshilov
