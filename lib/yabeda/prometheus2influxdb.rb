# frozen_string_literal: true

require "singleton"

require "influxdb"
require "yabeda/prometheus"

require_relative "prometheus2influxdb/config"
require_relative "prometheus2influxdb/version"

module Yabeda
  class Prometheus2InfluxDB
    include Singleton

    class Error < StandardError; end

    def self.start!
      instance.start!
    end

    def self.configured?
      instance.config.configured?
    end

    attr_reader :influxdb_client, :registry, :instance_label, :config

    def initialize
      @config = Config.new
      @influxdb_client = ::InfluxDB::Client.new(**config.to_h)
      @registry = Yabeda::Prometheus.registry
      @instance_label = "#{Socket.gethostname}##{Process.pid}"
    end

    def start!
      Thread.new do
        loop do
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          Yabeda.collect!
          influxdb_client.write_points(prepare_points)
          finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          sleep(config.export_interval_seconds - (finish - start))
        end
      end
    end

    private

    def prepare_points
      Yabeda::Prometheus.registry.metrics.map do |metric|
        series = metric.name.to_s
        metric.values.map do |tags, value|
          tags = tags.merge(instance: instance_label)
          case metric
          when ::Prometheus::Client::Counter, ::Prometheus::Client::Gauge
            { series: series, tags: tags, values: { value: value } }
          when ::Prometheus::Client::Histogram
            histogram_points(series, tags, value)
          else
            raise NotImplementedError, "#{metric.class} isn't supported for exporting to InfluxDB yet"
          end
        end
      end.flatten
    end

    def histogram_points(name, tags, bucketed_values)
      bucketed_values.map do |bucket, value|
        if bucket == "sum"
          { series: "#{name}_sum", tags: tags, values: { value: value } }
        else
          { series: "#{name}_bucket", tags: tags.merge("le" => bucket), values: { value: value } }
        end
      end
    end
  end
end
