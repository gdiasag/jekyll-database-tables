# frozen_string_literal: true

require 'helper'

class TestParser < Minitest::Test
  def test_parses_valid_markdown_table
    lines = [
      '| Name  | Age |',
      '|-------|-----|',
      '| Alice | 30  |',
      '| Bob   | 25  |'
    ]

    table = Jekyll::DatabaseTables::Parser.parse(lines)

    refute_nil table
    assert_equal %w[Name Age], table.headers

    rows = table.rows
    assert_equal 2, rows.length
    assert_equal %w[Alice 30], rows[0].cells
    assert_equal %w[Bob 25], rows[1].cells
  end

  def test_parses_table_without_leading_trailing_pipes
    lines = [
      'Name | Age',
      '-----|-----',
      'Alice | 30'
    ]

    table = Jekyll::DatabaseTables::Parser.parse(lines)

    refute_nil table
    assert_equal %w[Name Age], table.headers
    assert_equal [%w[Alice 30]], table.rows.map(&:cells)
  end

  def test_returns_nil_for_table_without_separator
    lines = [
      '| A | B |',
      '| 1 | 2 |'
    ]

    assert_nil Jekyll::DatabaseTables::Parser.parse(lines)
  end

  def test_returns_nil_for_single_line
    assert_nil Jekyll::DatabaseTables::Parser.parse(['| A |'])
  end

  def test_returns_nil_for_empty_array
    assert_nil Jekyll::DatabaseTables::Parser.parse([])
  end
end
