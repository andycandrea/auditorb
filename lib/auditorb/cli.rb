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

    desc 'number_of_gems', 'Returns the number of direct Ruby dependencies'
    def number_of_gems
      puts 'Number of direct Ruby dependencies'
      all_gems = Bundler.load.current_dependencies
      production_gems = all_gems.select do |dependency|
        dependency.groups.include?(:default) ||
          dependency.groups.include?(:production)
      end
      puts production_gems.length
    end

    desc 'stats', 'Run `rake stats`'
    def stats
      Rake.application.send(:load, 'Rakefile')
      Rake::Task['stats'].invoke
    end

    desc 'git_stats', 'Returns git statistics'
    def git_stats
      puts 'Git Statistics'
      data = GitAnalyzer.new.analyze
      Presenters::Stdout::Git.new(data).present
    end
  end
end
