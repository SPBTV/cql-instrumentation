require 'active_support/concern'

module CqlInstrumentation
  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    def append_info_to_payload(payload)
      super
      payload[:cassandra_runtime] = LogSubscriber.reset_runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages, cassandra_runtime = super, payload[:cassandra_runtime]
        messages << "Cassandra: #{cassandra_runtime.round(1)}ms" if cassandra_runtime
        messages
      end
    end
  end
end
