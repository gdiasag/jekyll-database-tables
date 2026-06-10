# frozen_string_literal: true

module Jekyll
  module DatabaseTables
    # Scans document content a nd replaces Markdown pipe tables with
    # database-style terminal table HTML.
    #
    # Lines inside fenced blocks (+```+ or +~~~+) are never treated as tables,
    # regardless of whether they contain pipe characters.
    class Converter
      # Convenience method - equivalent to +Converter.new.call(content)+.
      #
      # @param content [String] the raw document content
      # @return [String] the content with any Markdown tables converted
      def self.call(content)
        new.call(content)
      end

      # Scans +content+ line by line, buffering pipe-containing lines and
      # flishing the buffer through {Parser} and {Formatter} whenever a
      # non-pipe line (or end of input) is reached.
      #
      # @param content [String] the raw document content
      # @return [String] the content with any Markdown tables converted
      def call(content)
        lines = content.lines
        result = +''
        buffer = []
        fenced = false

        lines.each do |line|
          if line.match?(/^\s*(`{3,}|~{3,})/)
            result << process_buffer(buffer)
            buffer.clear
            fenced = !fenced
            result << line
          elsif !fenced && line.include?('|')
            buffer << line
          else
            result << process_buffer(buffer)
            buffer.clear
            result << line
          end
        end

        result << process_buffer(buffer)
        result
      end

      private

      def process_buffer(buffer)
        return buffer.join if buffer.empty?

        table = Parser.parse(buffer)

        if table.nil? && buffer.any? { |l| l.match?(Parser::SEPARATOR_PATTERN) }
          warn "[jekyll-database-tables] Could not parse table: #{buffer.join}"
        end

        table ? PsqlFormatter.new.render(table) : buffer.join
      end
    end
  end
end
