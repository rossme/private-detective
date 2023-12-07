# lib/private_detective.rb

# @example Usage in a Rails project
# private_detective = PrivateDetective::AnalyzeProject.new
# private_detective.analyze_project

module PrivateDetective
  require "parser/current"
  require "colorize"
  require_relative "./private_detective/analyze_project"
  require_relative "./private_detective/analyze_file"
  require_relative "./private_detective/analyze_node"
  require_relative "./private_detective/report"
  require_relative "./private_detective/version"

  class PrivateDetectiveError < StandardError; end
end
