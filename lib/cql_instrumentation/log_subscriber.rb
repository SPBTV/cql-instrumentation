require 'active_support/per_thread_registry'
require 'active_support/log_subscriber'

module CqlInstrumentation
  class LogSubscriber < ActiveSupport::LogSubscriber
    cattr_accessor :calculate_runtime

    def query(event)
      self.class.runtime += event.duration if self.class.calculate_runtime
      return unless logger.debug?

      cql = event.payload[:cql]
      binds = event.payload[:binds]
      name = "Cassandra Query (#{event.duration.round(1)}ms)"
      debug "  #{color(name, YELLOW, true)}  #{color(cql, nil, true)}  #{binds.any? ? binds.inspect : nil}"
    end

    def self.runtime=(value)
      RuntimeRegistry.cql_runtime = value
    end

    def self.runtime
      RuntimeRegistry.cql_runtime ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end
  end

  class RuntimeRegistry
    extend ActiveSupport::PerThreadRegistry

    attr_accessor :cql_runtime

    def self.cql_runtime
      instance.cql_runtime
    end

    def self.cql_runtime=(val)
      instance.cql_runtime = val
    end
  end
end
