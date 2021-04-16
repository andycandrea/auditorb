# frozen_string_literal: true

require 'active_support/all'
require 'auditorb/presenters/stdout/colorizer'
require 'auditorb/presenters/stdout/tableizer'

module Auditorb
  module Presenters
    module Stdout
      class Gemfile
        delegate :notice, :warn, :danger, to: :colorizer

        def initialize(data)
          @data = data
        end

        def present
          colorize_data
          puts 'Ruby dependency information'
          puts Tableizer.new(@data).to_table
        end

        private def colorize_data
          @data.each do |datum|
            colorize_version(datum)
            colorize_release(datum, :installed_version_release)
            colorize_release(datum, :latest_version_release)
            colorize_vulnerability(datum)
          end
        end

        private def colorize_version(datum)
          current = datum[:installed_version].split('.')
          latest = datum[:latest_version].split('.')

          return if current == latest

          if current.first != latest.first
            datum[:installed_version] = danger(datum[:installed_version])
          elsif current[1] != latest[1]
            datum[:installed_version] = warn(datum[:installed_version])
          else
            datum[:installed_version] = notice(datum[:installed_version])
          end
        end

        private def colorize_release(datum, key)
          release_date = datum[key]

          return if release_date > 1.month.ago

          if release_date > 6.months.ago
            datum[key] = notice(release_date.to_s)
          elsif release_date > 12.months.ago
            datum[key] = warn(release_date.to_s)
          else
            datum[key] = danger(release_date.to_s)
          end
        end

        private def colorize_vulnerability(datum)
          if datum[:vulnerability]
            datum[:vulnerability] = danger('Yes')
          else
            datum[:vulnerability] = 'No'
          end
        end

        private def colorizer
          @colorizer ||= Colorizer
        end
      end
    end
  end
end
