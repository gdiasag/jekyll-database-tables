# frozen_string_literal: true

require 'cgi'

module Jekyll
  module DatabaseTables
    # Abstract base class for table formatters.
    #
    # Subclasses must implement {#render}, {#format_row}, and {#separator}.
    # Shared rendering utilities are available via {Formatter::Helpers}.
    class Formatter
      # Optional mixin providing geometry utilities for formatter subclasses.
      #
      # Include this modules to gain access to {#column_widths}, which is useful
      # for any formatter that needs to align output by column.
      module Helpers
        # Computes the minimum column widths needed to fit all cell values.
        #
        # @param table [Table] the table to measure
        # @return [Array<Integer>] the maximum cell width for each column, in order
        def column_widths(table)
          col_count = table.headers.length
          all_rows  = [table.headers] + table.rows.map(&:cells)

          (0...col_count).map do |index|
            all_rows.map { |row| row[index].to_s.length }.max
          end
        end
      end

      # Renders a {Table} to a string.
      #
      # @param table [Table] the table to render
      # @param title [String, nil] an optional title to display above headers
      # @return [String] the rendered output
      # @raise [NotImplementedError] if the subclass does not implement this method
      def render(table, title: nil)
        raise NotImplementedError, "#{self.class} must implement #render"
      end

      # Formats a single row of cells into a string
      #
      # @param cells [Array<#to_s>] the cell values to render
      # @param widths [Array<Integer>] the column widths to align against
      # @return [String] the formatted row
      # @raise [NotImplementedError] if the subclass does not implement this method
      def format_row(cells, widths)
        raise NotImplementedError, "#{self.class} must implement #format_row"
      end

      # Renders the separator line between headers and data rows.
      #
      # @param widths [Array<Integer>] the column widths to size the separator against
      # @return [String] the separator line
      # @raise [NotImplementedError] if the subclass does not implement this method
      def separator(widths)
        raise NotImplementedError, "#{self.class} must implement #separator"
      end
    end

    # Renders a {Table} as a psql-style terminal table inside a +<pre>+ block.
    #
    # Output uses space-padded columns separated by +|+, with a +-+-+ divider
    # between the header and data rows. Intended to evoke a database query result.
    #
    # @example
    #   puts PsqlFormatter.new.render(table)
    #
    #   <pre class="psql-table">
    #   Name  | Age
    #   ------+----
    #   Alice | 30
    #   </pre>
    class PsqlFormatter < Formatter
      include Formatter::Helpers

      # Renders the table as a +<pre class="psql-table">+ block.
      #
      # @param table [Table] the table to render
      # @param title [String, nil] an optional title, centered above the headers
      # @return [String] the HTML +<pre>+ block
      def render(table, title: nil)
        widths = column_widths(table)

        lines = +''
        lines << "#{CGI.escapeHTML(title).center(total_width(widths)).rstrip}\n" if title

        lines << format_row(table.headers, widths)
        lines << "\n"
        lines << separator(widths)
        lines << "\n"

        table.rows.each do |row|
          lines << format_row(row.cells, widths)
          lines << "\n"
        end

        "<pre class=\"psql-table\">\n#{lines}</pre>\n"
      end

      # Formats a row as space-padded cells joined by +|+.
      #
      # @param cells [Array<#to_s>] the cell values to render
      # @param widths [Array<Integer>] the column widths to left-justify against
      # @return [String] the formatted row, with trailing whitespace stripped
      def format_row(cells, widths)
        cells.each_with_index.map do |cell, i|
          CGI.escapeHTML(cell.to_s.ljust(widths[i]))
        end.join(' | ').rstrip
      end

      # Renders a +-+-+ separator sized to the given column widths.
      #
      # @param widths [Array<Integer>] the column widths
      # @return [String] the separator line
      def separator(widths)
        widths.map { |w| '-' * w }.join('-+-')
      end

      private

      def total_width(widths)
        widths.sum + ((widths.length - 1) * 3)
      end
    end
  end
end
