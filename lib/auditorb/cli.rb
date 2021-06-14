# frozen_string_literal: true

require 'auditorb/gemfile_analyzer'
require 'auditorb/presenters/stdout/gemfile'
require 'auditorb/git_analyzer'
require 'auditorb/presenters/stdout/git'
require 'auditorb/presenters/stdout/churn'
require 'churn'
require 'churn/calculator'
require 'rake'
require 'thor'

module Auditorb
  class CLI < Thor
    desc 'all', 'Run all audit commands'
    def all
      steps = %i(analyze_gemfile number_of_gems stats git_stats churn)
      steps.each do |step|
        __send__(step)
        puts divider
      end
    end

    desc 'analyze_gemfile', 'Analyze your installed gems'
    long_desc <<~DESCRIPTION
      Analyze your installed gems.

      This audit will compare your installed gems to their latest versions and
      will tell you if any known vulnerabilities exist for your current version.

      This audit is meant to help you identify gems that have gotten out of date
      as well as gems that have not been recently maintained.
    DESCRIPTION
    def analyze_gemfile
      data = GemfileAnalyzer.new.analyze
      Presenters::Stdout::Gemfile.new(data).present
    end

    desc 'number_of_gems', 'Returns the number of direct Ruby dependencies'
    long_desc <<~DESCRIPTION
      Analyze your installed gems.

      This audit is meant to help you identify any projects that heavily rely on
      external code. If the number is higher than you expect, it may also help
      you discover dependencies that are no longer in use and can be removed.
    DESCRIPTION
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
    long_desc <<~DESCRIPTION
      Runs the `stats` task that comes with Rails.

      This audit gives some information on your test coverage and helps you see
      the makeup of your codebase. It might help you gain a sense of whether
      you're using anti-patterns such as fat controllers or fat models.
    DESCRIPTION
    def stats
      Rake.application.send(:load, 'Rakefile')
      Rake::Task['stats'].invoke
    end

    desc 'git_stats', 'Returns git statistics'
    long_desc <<~DESCRIPTION
      Returns the list of contributors sorted by number of commits.

      This audit is meant to help you determine how much institutional knowledge
      your organization has on a particular project. If a limited number of
      individuals that are currently associated with your organization have been
      contributing, you may wish to onboard additional developer to reduce the
      impact of those individuals changing jobs or otherwise leaving the
      organization.
    DESCRIPTION
    def git_stats
      puts 'Git Statistics'
      data = GitAnalyzer.new.analyze
      Presenters::Stdout::Git.new(data).present
    end

    # Switch to percentage
    desc 'churn', 'Returns the files ordered by churn'
    long_desc <<~DESCRIPTION
      Returns the files in your repository ordered by churn.

      Churn is often correlated with complexity, technical debt or "god" objects
      that likely violate the single responsibility principle. By identifying
      classes with high churn, you may discover good candidatets for refactoring
      that can reduce maintenance costs or the likelihood of bugs that may
      negatively impact your organization or its reputation.
    DESCRIPTION
    def churn
      calculator = Churn::ChurnCalculator.new(
        file_extension: 'rb|erb|js|coffee|css|scss|sql',
        start_date: '10 years ago',
        ignore_files: 'structure.sql, schema.rb',
        minimum_churn_count: 10
      )
      data = calculator.report(false)
      Presenters::Stdout::Churn.new(data).present
    end

    private def divider
      @divider ||= "\n\n".freeze
    end
  end
end
