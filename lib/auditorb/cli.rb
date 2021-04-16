# frozen_string_literal: true

require 'auditorb/gemfile_analyzer'
require 'auditorb/presenters/stdout/gemfile'
require 'auditorb/git_analyzer'
require 'auditorb/presenters/stdout/git'
require 'rake'
require 'thor'

module Auditorb
  class CLI < Thor
    desc 'analyze_gemfile', 'Analyze your installed gems'
    def analyze_gemfile
      data = GemfileAnalyzer.new.analyze
      Presenters::Stdout::Gemfile.new(data).present
    end

    desc 'git_stats', 'Returns git statistics'
    def git_stats
      puts 'Git Statistics'
      data = GitAnalyzer.new.analyze
      Presenters::Stdout::Git.new(data).present
    end
  end
end
