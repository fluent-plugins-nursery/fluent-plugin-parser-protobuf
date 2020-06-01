require_relative '../test_helper'
require 'date'
require 'fluent/test/helpers'
require 'json'
require 'fluent/test/driver/parser'
require_relative "../data/protobuf3/simple_pb"
require_relative "../data/protobuf3/nested_pb"

class ProtobufParserFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf='')
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::ProtobufParser).configure(conf)
  end

  class Protobuf3 < self
    def encoded_simple_binary
      request = SearchRequest.new(query: "q=Fluentd",
                                  page_number: 404,
                                  result_per_page: 10,
                                  corpus: :WEB,
                                  timestamp: Time.now)
      SearchRequest.encode(request)
    end

    def encoded_nested_class_binary
      response = SearchResponse::Result.new(url: "https://docs.fluent.org",
                                   title: "Fluentd Documentation",
                                   snippets: ["First page", "Second page", "Introduction"])

      SearchResponse::Result.encode(response)
    end

    CONFIG = %[
      class_name "SearchRequest"
      class_file #{File.expand_path(File.join(__dir__, "..", "data", "protobuf3", "simple_pb.rb"))}
    ]

    CONFIG_NESTED = %[
      class_name "SearchResponse.Result"
      class_file #{File.expand_path(File.join(__dir__, "..", "data", "protobuf3", "nested_pb.rb"))}
    ]

    def test_parse_simple
      d = create_driver(CONFIG)
      binary = encoded_simple_binary
      d.instance.parse(binary) do |_time, text|
        assert_equal "q=Fluentd", text[:query]
        assert_equal 404, text[:page_number]
        assert_equal 10, text[:result_per_page]
        assert_equal :WEB, text[:corpus]
        assert_equal Integer, text[:timestamp][:seconds].class
        assert_equal Integer, text[:timestamp][:nanos].class
      end
    end

    def test_nested
      d = create_driver(CONFIG_NESTED)
      binary = encoded_nested_class_binary
      d.instance.parse(binary) do |_time, text|
        assert_equal "https://docs.fluent.org", text[:url]
        assert_equal "Fluentd Documentation", text[:title]
        assert_equal ["First page", "Second page", "Introduction"], text[:snippets]
      end
    end
  end
end
