# frozen_string_literal: true

require 'active_support/all'

module Auditorb
  module Presenters
    module Stdout
      class Tableizer
        def initialize(data)
          @data = data
        end

        def to_table
          table = [divider]
          table << header_row
          table << divider
          @data.each { |datum| table << datum_row(datum) }
          table << divider
          table.join("\n")
        end

        private def header_row
          content = headers
            .map { |header| header.to_s.titleize.ljust(column_widths[header]) }
            .join(' | ')
          "| #{content} |"
        end

        private def datum_row(datum)
          content = datum
            .map do |key, val|
              width = column_widths[key]
              formatted_val = val.to_s.uncolorize.ljust(width)
              formatted_val.gsub(val.to_s.uncolorize, val.to_s)
            end.join(' | ')
          "| #{content} |"
        end

        private def divider
          return @divider if @divider

          columns = column_widths.values.map { |width| '-' * width }.join('-+-')
          @divider = "+-#{columns}-+".freeze
        end

        private def column_widths
          @column_widths ||= headers.reduce({}) do |columns, header|
            columns[header] = [
              header.to_s.titleize.length,
              @data.map { |datum| datum[header].to_s.uncolorize.length }.max
            ].max

            columns
          end.freeze
        end

        private def headers
          @headers ||= @data.map(&:keys).flatten.uniq.freeze
        end
      end
    end
  end
end
