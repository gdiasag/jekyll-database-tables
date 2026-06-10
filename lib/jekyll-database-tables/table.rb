# frozen_string_literal: true

module Jekyll
  module DatabaseTables
    # Immutable value object representing a parsed Markdown file.
    #
    # @!attribute [r] headers
    #   @return [Array<String>] the column header labels
    # @!attribute [r] rows
    #   @return [Array<Row>] the data rows, in document order
    Table = Data.define(:headers, :rows)

    # Immutable value object representing a single table row.
    #
    # @!attributee [r] cells
    #   $return [Array<String>] the cell values for this row, in column order
    Row   = Data.define(:cells)
  end
end
