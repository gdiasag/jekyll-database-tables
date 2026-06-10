# frozen_string_literal: true

module Jekyll
  module DatabaseTables
    # Parsers an array of Markdown table lines into a {Table}.
    #
    # Accepts both fenced (`| col |`) and unfenced (`col |`) pipe styles.
    # Returns +nil+ for any input that does not constitute a valid table.
    module Parser
      # Matches a GFM table separator line.
      SEPARATOR_PATTERN = /^\|?[\s:-]+\|/

      module_function

      # Parses a buffer of lines into a {Table}.
      #
      # Expects at least two lines where the second matches {SEPARATOR_PATTERN}.
      # Any additional lines are treated as data rows.
      #
      # @param lines [Array<String>] raw lines from the document buffer
      # @return [Table, nil] the parsed table, or +nil+ if the input isn't valid
      def parse(lines)
        return if lines.length < 2
        return unless lines[1].match?(SEPARATOR_PATTERN)

        headers = split_cells(lines[0])
        rows    = lines.drop(2).map { |line| Row.new(split_cells(line)) }

        Table.new(headers:, rows:)
      end

      def split_cells(line)
        line
          .strip
          .delete_prefix('|')
          .delete_suffix('|')
          .split('|')
          .map(&:strip)
      end
    end
  end
end
