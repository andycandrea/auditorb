# frozen_string_literal: true

require 'auditorb/gemfile_analyzer'
require 'auditorb/presenters/stdout/gemfile'
require 'rake'
require 'thor'

module Auditorb
  class CLI < Thor
    desc 'analyze_gemfile', 'Analyze your installed gems'
    def analyze_gemfile
      data = GemfileAnalyzer.new.analyze
      Presenters::Stdout::Gemfile.new(data).present
    end
  end
end
