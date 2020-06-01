require "pathname"
require 'google/protobuf'
require 'protocol_buffers'

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
      config_param :protobuf_version, :enum, list: [:protobuf2, :protobuf3], default: :protobuf3
      config_param :class_name, :string

      def configure(conf)
        super
        loading_required = Google::Protobuf::DescriptorPool.generated_pool.lookup(class_name).nil?

        load_protobuf_class(@class_file) if loading_required && @class_file

        include_paths.each {|path| load_protobuf_definition(path)} if !include_paths.empty? && loading_required

        if @protobuf_version == :protobuf2
          @protobuf_descriptor = create_prptobuf2_instance(@class_name)
        elsif @protobuf_version == :protobuf3
          @protobuf_descriptor = Google::Protobuf::DescriptorPool.generated_pool.lookup(@class_name).msgclass
        end
      end

      def parse(binary)
        if @protobuf_version == :protobuf3
          decoded = @protobuf_descriptor.decode(binary.to_s)
          time = @estimate_current_event ? Fluent::EventTime.now : nil
          yield time, decoded.to_h
        elsif @protobuf_version == :protobuf2
          decoded = @protobuf_descriptor.parse(binary.to_s)
          time = @estimate_current_event ? Fluent::EventTime.now : nil
          yield time, decoded.to_hash
        end
      end

      def create_prptobuf2_instance(class_name)
        unless Object.const_defined?(class_name)
          raise Fluent::ConfigError, "Cannot find class #{class_name}."
        else
          Object.const_get(class_name)
        end
      end

      def load_protobuf_class(filename)
        if Pathname.new(filename).absolute?
          begin
            require filename
          rescue LoadError => e
            raise Fluent::ConfigError, "Unable to load protobuf definition class file: #{filename}. error: #{e.backtrace}"
          end
        else
          begin
            require_relative filename
          rescue LoadError => e
            raise Fluent::ConfigError, "Unable to load protobuf definition class file: #{filename}. error: #{e.backtrace}"
          end
        end
      end
    end
  end
end
