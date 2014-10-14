# Cassandra CQL Instrumentations

Performs logging for [cql-rb](https://github.com/iconara/cql-rb) queries and durations similar to ActiveRecord logging for SQL queries.

Example logs:

```
Cassandra Query (34.1ms)  SELECT * FROM timeseries WHERE name = ?  ["counts"]
Completed 200 OK in 141ms (Views: 7.8ms | ActiveRecord: 0.0ms | Cassandra: 117.3ms)
```

## Usage With Rails

All you need to do is to add this line to your application's Gemfile:

```
gem 'cql-instrumentation'
```

## Usage Without Rails

If you want to use this logging without Rails, setup it manually:

```ruby
ActiveSupport::LogSubscriber.logger = mylogger
CqlInstrumentation.setup_instrumentation
CqlInstrumentation.attach_log_subscriber
```

Full example:

```ruby
require 'cql'
require 'cql/instrumentation'
require 'logger'

logger = Logger.new(STDOUT)
ActiveSupport::LogSubscriber.logger = logger

CqlInstrumentation.setup_instrumentation
CqlInstrumentation.attach_log_subscriber

Cql::Client.connect.execute('SELECT * FROM timeseries WHERE name = ?', 'counts')
```

And you'll get:

```
Cassandra Query (1.7ms)  SELECT * FROM timeseries WHERE name = ?  ["counts"]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cql-instrumentation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright 2014 SPB TV AG

Licensed under the Apache License, Version 2.0 (the ["License"](LICENSE)); you may not use this file except in compliance with the License.

You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 

See the License for the specific language governing permissions and limitations under the License.

