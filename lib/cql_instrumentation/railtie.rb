module CqlInstrumentation
  class Railtie < Rails::Railtie
    initializer "cql_instrumentation" do
      CqlInstrumentation.setup_instrumentation
      CqlInstrumentation.attach_log_subscriber

      ActiveSupport.on_load(:action_controller) do
        include ControllerRuntime
        LogSubscriber.calculate_runtime = true
      end
    end
  end
end
