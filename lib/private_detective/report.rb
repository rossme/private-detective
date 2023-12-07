# frozen_string_literal: true

module PrivateDetective
  class Report

    class << self

      def generate(report:)
        return puts 'No class methods found'.colorize(:red) if report.empty?

        puts "Private Detective found the following Class method information in your project:\n".colorize(:yellow)

        report.each do |class_name, methods|
          puts "Class: #{class_name}".colorize(:cyan)
          methods.each do |method_info|
            method_name = method_info[:method]

            puts "  Method: #{method_name}, visibility: #{format_visibility(method_info[:visibility])}"
            on_send_values = method_info[:on_send]
            next if on_send_values.empty?

            puts "\tMethod contents:"
            handle_on_send_values(report, method_info)
          end
          puts "\n"
        end
        puts 'End of report'.colorize(:cyan)
      end

      def handle_on_send_values(report, method_info)
        values = method_info[:on_send]

        values.each do |_k, v|
          method = v[:method]
          klass = v[:class]

          # find the parent method info
          method_info = report[klass].find { |m| m[:method] == method }
          next unless method_info

          puts "\t\t#{method_info[:file_path]}:#{v.dig(:location, :line)}:#{v.dig(:location, :column)} #{klass.to_s.colorize(:cyan)}##{method.to_s.colorize(:cyan)} #{format_visibility(method_info[:visibility], true)}"
        end
      end

      def format_visibility(visibility, on_send = false)
        case visibility
        when :private
          visibility.to_s.colorize(:red) + (on_send ? ' [Correctable]'.colorize(:green) : '')
        when :protected
          visibility.to_s.colorize(:yellow) + (on_send ? ' [Correctable]'.colorize(:green) : '')
        else # :public
          visibility.to_s.colorize(:green)
        end
      end
    end
  end
end
