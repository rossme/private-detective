# frozen_string_literal: true

module PrivateDetective

  class AnalyzeProject

    attr_accessor :files, :report

    # @param [Array] files
    def initialize(files:)
      @files = files
      @report = {}
    end

    def analyze_project
      analyze_files
      filter_report
      show_report

      # Exit the IRB session after the report is shown
      exit
    end

    private

    def analyze_files
      files.each do |file_path|
        analyze_file(file_path)
      end
    end

    # @return [Hash] report with empty classes and methods removed
    def filter_report
      report.delete_if { |_class_name, methods| methods.empty? }
    end

    # @param [String] file_path
    def analyze_file(file_path)
      investigation = PrivateDetective::AnalyzeFile.new(file_path: file_path, report: report)
      investigation.analyze_file
    end

    def show_report
      return puts "No class methods found".colorize(:red) if report.empty?

      PrivateDetective::Report.generate(report: report)
    end
  end
end
