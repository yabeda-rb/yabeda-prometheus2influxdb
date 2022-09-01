# Yabeda::Prometheus2InfluxDB

Experimental gem to push metrics in Prometheus format (especially histograms) to InfluxDB endpoint.

Can be useful in environments where deploying Prometheus is complicated, but you can (e.g. for sending metrics to Grafana Cloud from non-containerized application on Cloud66 with many processes per server).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add yabeda-prometheus2influxdb

Configure InfluxDB connection with [anyway_config](https://github.com/palkan/anyway_config). See the [list of configuration options](https://github.com/influxdata/influxdb-ruby#list-of-configuration-options).

## Usage

Launch export in a different thread in some process (where applicable):

```ruby
Yabeda::Prometheus2InfluxDB.start!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yabeda-prometheus2influxdb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
