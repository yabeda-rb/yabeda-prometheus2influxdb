# frozen_string_literal: true

require "anyway_config"

module Yabeda
  class Prometheus2InfluxDB
    class Config < ::Anyway::Config
      config_name :yabeda_prometheus2influxdb

      attr_config export_interval_seconds: 60
      attr_config :url, :host, :port, :use_ssl, :verify_ssl, :ssl_ca_cert,
                  :prefix, :database, :username, :password, :auth_method,
                  :open_timeout, :read_timeout,
                  :retry, :initial_delay, :max_delay,
                  :time_precision, :epoch,
                  :async, :udp, :discard_write_errors, :chunk_size, :denormalize

      def configured?
        !!url || !!host
      end
    end
  end
end
