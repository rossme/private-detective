# frozen_string_literal: true

module PrivateDetective
  class AnalyzeFile

    attr_reader :file_path, :report, :node

    # @param [String] file_path, [Hash] report
    def initialize(file_path:, report:)
      @file_path = file_path
      @report = report
    end

    # @return [Hash] report
    def analyze_file
      @node = Parser::CurrentRuby.parse(File.read(file_path))
      return unless node.is_a?(Parser::AST::Node)

      analyze_node
    end

    private

    # @return [Hash] report
    def analyze_node
      analyze_node = PrivateDetective::AnalyzeNode.new(node: node, file_path: file_path)
      analyze_node.process_node

      report.merge!(analyze_node.report)
    end
  end
end
