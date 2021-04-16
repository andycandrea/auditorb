# frozen_string_literal: true

require 'active_support/all'
require 'auditorb/presenters/stdout/colorizer'
require 'auditorb/presenters/stdout/tableizer'

module Auditorb
  module Presenters
    module Stdout
      class Git
        delegate :danger, to: :colorizer

        def initialize(data)
          @data = data
        end

        def present
          colorize_data
          puts 'Git Statistics'
          puts "Number of commits on master but not develop: #{@data[:commits][:master_not_develop]}"
          puts "Number of commits on develop but not master: #{@data[:commits][:develop_not_master]}"
          puts 'Commits by author (develop)'
          puts contributor_table
        end

        private def colorize_data
          colorize_commit_count(:master_not_develop)
          colorize_commit_count(:develop_not_master)
        end

        private def contributor_table
          ordered_data = @data[:contributors].sort_by do |datum|
            datum[:commit_count]
          end.reverse
          Tableizer.new(ordered_data).to_table
        end

        private def colorize_commit_count(key)
          count = @data[:commits][key]

          return if count.zero?

          @data[:commits][key] = danger(count)
        end

        private def colorizer
          @colorizer ||= Colorizer
        end
      end
    end
  end
end
