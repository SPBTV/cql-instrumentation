require 'minitest/autorun'
require_relative '../lib/cql_instrumentation'
require 'logger'

class CqlInstrumentationTest < Minitest::Test
  class FakeLogger < Logger
    attr_accessor :debug_called

    def debug(*args)
      self.debug_called = true
      super
    end
  end

  class FakeClient
    def execute(cql, *binds)
    end
  end

  CqlInstrumentation.send(:instrument, FakeClient)
  CqlInstrumentation.attach_log_subscriber
  CqlInstrumentation::LogSubscriber.calculate_runtime = true

  def setup
    @client = FakeClient.new
    @logger = FakeLogger.new('/dev/null')
    ActiveSupport::LogSubscriber.logger = @logger
  end

  def test_query_logging
    @client.execute('SELECT * FROM timeseries WHERE value = ?', 1)
    assert @logger.debug_called, 'Query was not logged'
  end

  def test_runtime_calculation
    @client.execute('SELECT * FROM timeseries WHERE value = ?', 1)
    assert CqlInstrumentation::LogSubscriber.reset_runtime > 0, 'Execution time was not calculated'
  end
end
