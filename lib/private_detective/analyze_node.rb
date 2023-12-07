# frozen_string_literal: true

module PrivateDetective
  class AnalyzeNode

    ACCESS_CONTROL_KEYWORDS = %i[public private protected].freeze

    attr_reader :class_details, :super_class, :class_body, :file_path, :report

    # @param [Parser::AST::Node] node, [String] file_path
    def initialize(node:, file_path: nil)
      @class_details, @super_class, @class_body = *node
      @file_path = file_path
      @report = { class_name => [] }
    end

    # @return [Hash] report
    def process_node
      return unless class_pattern?

      create_report
    end

    private

    # @return [Hash] report
    def create_report
      class_body.children.each do |child_node|
        next unless def_method?(child_node)

        report[class_name] << build_method_hash(child_node)
      end
    end

    # @return [Boolean]
    def class_pattern?
      class_name && super_class&.children[1] == :ApplicationRecord && class_body&.type == :begin
    end

    # @return [Boolean]
    def def_method?(child_node)
      child_node&.type == :def
    end

    # @return [Hash] method name, class name, visibility, on_send, location
    def build_method_hash(child_node)
      {
        file_path: shortened_file_path,
        class: class_name,
        method: child_node.children[0],
        visibility: method_visibility(child_node),
        on_send: build_send_hash(child_node),
        location: {
          location: child_node.location,
          line: child_node.location.line,
          column: child_node.location.column,
          source: child_node.location.expression.source
        }
      }
    end

    # @return [Hash] send_method_hash(send_node)
    # @example { 0 => { method: :my_user_method, class: :user } }
    def build_send_hash(child_node)
      send_hash = {}
      child_node.children[2].children.each_with_index do |send_node, index|
        next unless valid_send_node?(send_node)

        send_hash.merge!(index => send_method_hash(send_node))
      end
      send_hash
    end

    # @return [Boolean]
    def valid_send_node?(send_node)
      return false unless send_node.is_a?(Parser::AST::Node)

      send_node.type == :send && send_node.children&.first&.type == :const
    end

    # @return [Hash] method name and class name
    def send_method_hash(send_node)
      {
        method: send_node.children[1],
        class: send_node.children[0].children[1],
        location: {
          location: send_node.location,
          line: send_node.location.line,
          column: send_node.location.column,
          source: send_node.location.expression.source
        }
      }
    end

    # @return [Symbol] visibility
    # @example :public, :private, :protected
    def method_visibility(child_node)
      visibility = :public

      while child_node
        if child_node.type == :send && ACCESS_CONTROL_KEYWORDS.include?(child_node.children[1])
          visibility = child_node.children[1]
          break
        end
        child_node = sibling_index(child_node).zero? ? nil : sibling_node(child_node)
      end

      visibility
    end

    # @return [Integer] index of child_node in parent_node
    def sibling_index(child_node)
      class_body&.children&.index { |sibling| sibling.equal?(child_node) }
    end

    # @return [Parser::AST::Node] sibling node
    def sibling_node(child_node)
      class_body.children[sibling_index(child_node) - 1]
    end

    # @return [Symbol] class name
    def class_name
      @class_name ||= class_details&.children&.last
    end

    def shortened_file_path
      @shortened_file_path ||= file_path&.split('/').last(2).join('/')
    end
  end
end
