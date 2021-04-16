# frozen_string_literal: true

require 'colorize'

module Auditorb
  module Presenters
    module Stdout
      class Colorizer
        def self.danger(value)
          value.to_s.colorize(:red)
        end

        def self.warn(value)
          value.to_s.colorize(:light_red)
        end

        def self.notice(value)
          value.to_s.colorize(:yellow)
        end
      end
    end
  end
end
