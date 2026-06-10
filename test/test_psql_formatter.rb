# frozen_string_literal: true

require 'helper'

class TestPsqlFormatter < Minitest::Test
  def setup
    @formatter = Jekyll::DatabaseTables::PsqlFormatter.new
  end

  def test_renders_simple_table
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[Alice 30]),
      Jekyll::DatabaseTables::Row.new(cells: %w[Bob 25])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[Name Age],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      Name  | Age
      ------+----
      Alice | 30
      Bob   | 25
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_renders_with_title
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[Alice 30])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[Name Age],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
         Users
      Name  | Age
      ------+----
      Alice | 30
      </pre>
    HTML

    assert_equal expected, @formatter.render(table, title: 'Users')
  end

  def test_renders_single_column
    table = Jekyll::DatabaseTables::Table.new(
      headers: ['Value'],
      rows: [Jekyll::DatabaseTables::Row.new(cells: ['42'])]
    )

    expected = <<~HTML
      <pre class="psql-table">
      Value
      -----
      42
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_renders_numeric_cells
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: [42, 3.14])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[Count Pi],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      Count | Pi
      ------+-----
      42    | 3.14
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end
end
