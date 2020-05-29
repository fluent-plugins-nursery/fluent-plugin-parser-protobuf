# fluent-plugin-parser-protobuf

Fluentd parser plugin for [Protocol Buffers](https://developers.google.com/protocol-buffers/docs/overview).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-parser-protobuf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fluent-plugin-parser-protobuf

## Configuration

```aconf
<parse>
  @type protobuf
  class_file /path/to/your/protobuf/class_file
  class_name YourProtobufClassName
  # include_paths [/path/to/your/protobuf/class_file, /path/to/your/protobuf/class_file2, ...]
</parse>
```

**Note:** Protobuf version 3 requires to use dot for nested class name seperator:

`Your::Protobuf::Class::Name` class should be in class_name as follows:
```
class_name Your.Protobuf.Class.Name
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cosmo0920/fluent-plugin-parser-protobuf.

## LICENSE

[Apache-2.0](LICENSE).
