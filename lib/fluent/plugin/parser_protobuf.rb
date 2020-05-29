require "pathname"
require 'google/protobuf'

require "fluent/env"
require "fluent/plugin/parser"
require 'fluent/time'

module Fluent
  module Plugin
    class ProtobufParser < Parser
      Plugin.register_parser('protobuf', self)

      class Error < StandardError; end

      config_param :include_paths, :array, default: []
      config_param :class_file, :string, default: nil
      config_param :protobuf_version, :enum, list: [:"3"], default: :"3"
      config_param :class_name, :string

      def configure(conf)
        super
        loading_required = Google::Protobuf::DescriptorPool.generated_pool.lookup(class_name).nil?

        load_protobuf_class(@class_file) if loading_required && @class_file

        include_paths.each {|path| load_protobuf_definition(path)} if !include_paths.empty? && loading_required

        @protobuf_descriptor = Google::Protobuf::DescriptorPool.generated_pool.lookup(@class_name).msgclass
      end

      def parse(binary)
        decoded = @protobuf_descriptor.decode(binary.to_s)
        time = @estimate_current_event ? Fluent::EventTime.now : nil
        yield time, decoded.to_h
      end

      def load_protobuf_class(filename)
        if Pathname.new(filename).absolute?
          begin
            require filename
          rescue LoadError => e
            Fluent::ConfigError "Unable to load protobuf definition class file: #{filename}. error: #{e.backtrace}"
          end
        else
          begin
            require_relative filename
          rescue LoadError => e
            Fluent::ConfigError "Unable to load protobuf definition class file: #{filename}. error: #{e.backtrace}"
          end
        end
      end
    end
  end
end
