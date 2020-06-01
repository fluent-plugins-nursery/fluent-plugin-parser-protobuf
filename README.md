# fluent-plugin-parser-protobuf

![Testing on Windows](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf/workflows/Testing%20on%20Windows/badge.svg?branch=master)
![Testing on macOS](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf/workflows/Testing%20on%20macOS/badge.svg?branch=master)
![Testing on Ubuntu](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf/workflows/Testing%20on%20Ubuntu/badge.svg?branch=master)

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

## Prerequisites to use

Users should prepare protocol buffers with the following compilers:

* For Protocol Buffers 2, using [ruby-protoc compiler](https://github.com/codekitchen/ruby-protocol-buffers) is needed.
* For Protocol Buffers 3, using [the official protoc compiler](https://developers.google.com/protocol-buffers/docs/reference/ruby-generated) is needed.

## Configuration

**Note:** Protocol Buffer v2 files use `.pb.rb` extensions whereas Protocol Buffer v3 files use `_pb.rb` in their filename endings. Please be careful which version is used in your protobuf definitions.

### For Protobuf 3

```aconf
<parse>
  @type protobuf
  class_file /path/to/your/protobuf/class_file_pb.rb
  class_name Your.Protobuf.Class.Name # For protobuf3
  protobuf_version protobuf3
  # include_paths [/path/to/your/protobuf/class_file_pb.rb, /path/to/your/protobuf/class_file2_pb.rb, ...]
</parse>
```

**Note:** Protobuf version 3 requires to use dot for nested class name seperator:

`Your::Protobuf::Class::Name` class should be in class_name as follows:
```
class_name Your.Protobuf.Class.Name
```

### For Protobuf 2

```aconf
<parse>
  @type protobuf
  class_file /path/to/your/protobuf/class_file.pb.rb
  class_name Your::Protobuf::Class::Name # For protobuf2
  protobuf_version protobuf2
  # include_paths [/path/to/your/protobuf/class_file.pb.rb, /path/to/your/protobuf/class_file2.pb.rb, ...]
</parse>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf.

## LICENSE

[Apache-2.0](LICENSE).
