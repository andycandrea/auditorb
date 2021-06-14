# frozen_string_literal: true

require 'active_support/all'
require 'auditorb/presenters/stdout/colorizer'
require 'auditorb/presenters/stdout/tableizer'

module Auditorb
  module Presenters
    module Stdout
      class Churn
        delegate :notice, :warn, :danger, to: :colorizer

        def initialize(data)
          @data = data[:churn][:changes]
        end

        def present
          colorize_data
          puts 'Git churn data'
          puts Tableizer.new(@data).to_table
        end

        private def colorize_data
          @data.each { |datum| colorize_times_changed(datum) }
        end

        private def colorize_times_changed(datum)
          times_changed = datum[:times_changed] || 0

          return if times_changed < 10

          if times_changed <= 25
            datum[:times_changed] = notice(times_changed)
          elsif times_changed <= 50
            datum[:times_changed] = warn(times_changed)
          else
            datum[:times_changed] = danger(times_changed)
          end
        end

        private def colorizer
          @colorizer ||= Colorizer
        end
      end
    end
  end
end
