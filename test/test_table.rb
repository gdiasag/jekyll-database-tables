# frozen_string_literal: true

require 'helper'

class TestTable < Minitest::Test
  def test_table_has_headers_and_rows
    row = Jekyll::DatabaseTables::Row.new(cells: %w[Alice 30])
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[Name Age],
      rows: [row]
    )

    assert_equal %w[Name Age], table.headers
    assert_equal 1, table.rows.length
    assert_equal %w[Alice 30], table.rows[0].cells
  end

  def test_table_instance_is_frozen
    table = Jekyll::DatabaseTables::Table.new(headers: ['A'], rows: [])
    assert table.frozen?
  end

  def test_row_instance_is_frozen
    row = Jekyll::DatabaseTables::Row.new(cells: ['x'])
    assert row.frozen?
  end
end
