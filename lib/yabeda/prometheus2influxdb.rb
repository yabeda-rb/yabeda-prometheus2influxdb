# frozen_string_literal: true

require "singleton"

require "influxdb"
require "yabeda/prometheus/mmap"

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

    attr_reader :influxdb_client, :instance_label, :config

    def initialize
      @config = Config.new
      @influxdb_client = ::InfluxDB::Client.new(**config.to_h)
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
      metrics = ::Prometheus::Client::Formats::Text.send(:load_metrics, ::Prometheus::Client.configuration.multiprocess_files_dir)
      metrics.map do |_, samples:, **|
        samples.map do |series, tags, value|
          tags = Hash[tags].merge("instance" => instance_label)
          { series: series, tags: tags, values: { value: value } }
        end
      end.flatten
    end
  end
end
