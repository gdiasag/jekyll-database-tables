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

  def test_escapes_html_in_cells
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: ['<x>', 'y&z']),
      Jekyll::DatabaseTables::Row.new(cells: ['"hi"', 'a>b'])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[A B],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      A    | B
      -----+----
      &lt;x&gt;  | y&amp;z
      &quot;hi&quot; | a&gt;b
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_escapes_html_in_headers
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[x y])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: ['<a>', '<b>'],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      &lt;a&gt; | &lt;b&gt;
      ----+----
      x   | y
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_escapes_html_in_title
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[Alice 30])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[Name Age],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      Users &amp; Guests
      Name  | Age
      ------+----
      Alice | 30
      </pre>
    HTML

    assert_equal expected, @formatter.render(table, title: 'Users & Guests')
  end

  def test_escapes_html_preserves_safe_content
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[Alice 30])
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
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_escapes_html_empty_cells
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: ['', '<>'])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: ['', ''],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
       |
      -+---
       | &lt;&gt;
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_escapes_html_double_encoding
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: ['&amp;', '&lt;'])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[A B],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      A     | B
      ------+-----
      &amp;amp; | &amp;lt;
      </pre>
    HTML

    assert_equal expected, @formatter.render(table)
  end

  def test_escapes_html_nil_title
    rows = [
      Jekyll::DatabaseTables::Row.new(cells: %w[a b])
    ]
    table = Jekyll::DatabaseTables::Table.new(
      headers: %w[X Y],
      rows:
    )

    expected = <<~HTML
      <pre class="psql-table">
      X | Y
      --+--
      a | b
      </pre>
    HTML

    assert_equal expected, @formatter.render(table, title: nil)
  end
end
