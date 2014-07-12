require 'active_support/notifications'
require 'active_support/core_ext/module/aliasing'

module CqlInstrumentation
  SERVICE_ID = :cassandra

  class << self
    def setup_instrumentation
      instrument(Cql::Client::SynchronousClient)
    end

    def attach_log_subscriber
      LogSubscriber.attach_to(SERVICE_ID)
    end

    private

    def instrument(klass)
      klass.class_eval do
        def execute_with_instrumentation(cql, *binds)
          ActiveSupport::Notifications.instrument("query.#{SERVICE_ID}", cql: cql, binds: binds) do
            execute_without_instrumentation(cql, *binds)
          end
        end

        alias_method_chain :execute, :instrumentation unless method_defined?(:execute_without_instrumentation)
      end
    end
  end

  require_relative 'cql_instrumentation/version'
  require_relative 'cql_instrumentation/log_subscriber'
  require_relative 'cql_instrumentation/controller_runtime'
  require_relative 'cql_instrumentation/railtie' if defined?(Rails)
end
