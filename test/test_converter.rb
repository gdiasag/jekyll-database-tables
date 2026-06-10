# frozen_string_literal: true

require 'helper'

class TestConverter < Minitest::Test
  def test_converts_full_markdown_table
    input = <<~MD
      | Name  | Age |
      |-------|-----|
      | Alice | 30  |
      | Bob   | 25  |
    MD

    expected = <<~HTML
      <pre class="psql-table">
      Name  | Age
      ------+----
      Alice | 30
      Bob   | 25
      </pre>
    HTML

    assert_equal expected, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_leaves_non_table_content_unchanged
    input = "Hello world.\n\nNothing to see here.\n"

    assert_equal input, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_preserves_text_before_and_after_table
    input = <<~MD
      Before.

      | A | B |
      |---|---|
      | 1 | 2 |

      After.
    MD

    expected = <<~HTML
      Before.

      <pre class="psql-table">
      A | B
      --+--
      1 | 2
      </pre>

      After.
    HTML

    assert_equal expected, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_ignores_single_pipe_line
    input = "| Not a table\njust a line\n"

    assert_equal input, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_ignores_table_without_separator
    input = "| A | B |\n| 1 | 2 |\n"

    assert_equal input, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_empty_content
    assert_equal '', Jekyll::DatabaseTables::Converter.call('')
  end

  def test_converts_multiple_tables
    input = <<~MD
      First:

      | X |
      |---|
      | 1 |

      Second:

      | Y |
      |---|
      | 2 |
    MD

    expected = <<~HTML
      First:

      <pre class="psql-table">
      X
      -
      1
      </pre>

      Second:

      <pre class="psql-table">
      Y
      -
      2
      </pre>
    HTML

    assert_equal expected, Jekyll::DatabaseTables::Converter.call(input)
  end

  def test_ignores_code_fence
    input = <<~MD
      ```
      | A | B |
      |---|---|
      | 1 | 2 |
      ```
    MD

    assert_equal input, Jekyll::DatabaseTables::Converter.call(input)
  end
end
