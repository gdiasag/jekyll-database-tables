# frozen_string_literal: true

module Jekyll
  module DatabaseTables
    # Scans document content and replaces Markdown pipe tables with
    # database-style terminal table HTML.
    #
    # Lines inside fenced blocks (+```+ or +~~~+) are never treated as tables,
    # regardless of whether they contain pipe characters.
    class Converter
      FENCE_PATTERN = /^\s*(`{3,}|~{3,})/

      # Convenience method - equivalent to +Converter.new(formatter:).call(content)+.
      #
      # @param content [String] the raw document content
      # @param formatter [String] the formatter to use (default: +'psql'+)
      # @return [String] the content with any Markdown tables converted
      def self.call(content, formatter: 'psql')
        new(formatter:).call(content)
      end

      def initialize(formatter: 'psql')
        @formatter = formatter
      end

      # Scans +content+ line by line, buffering pipe-containing lines and
      # flushing the buffer through {Parser} and {Formatter} whenever a
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
          if fenced || !line.include?('|')
            flush_buffer(result, buffer, line)
            fenced = !fenced if fence_line?(line)
          else
            buffer << line
          end
        end

        flush_buffer(result, buffer)
        result
      end

      private

      def fence_line?(line)
        line.match?(FENCE_PATTERN)
      end

      def flush_buffer(result, buffer, line = nil)
        result << process_buffer(buffer)
        buffer.clear
        result << line if line
      end

      def process_buffer(buffer)
        return buffer.join if buffer.empty?

        table = Parser.parse(buffer)

        if table.nil? && buffer.any? { |l| l.match?(Parser::SEPARATOR_PATTERN) }
          warn "[jekyll-database-tables] Could not parse table: #{buffer.join}"
        end

        table ? formatter_instance.render(table) : buffer.join
      end

      def formatter_instance
        case @formatter
        when 'psql' then PsqlFormatter.new
        else raise ArgumentError, "Unknown formatter: #{@formatter.inspect}"
        end
      end
    end
  end
end
