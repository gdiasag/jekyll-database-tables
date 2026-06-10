# frozen_string_literal: true

require 'helper'

class TestVersion < Minitest::Test
  def test_version_is_defined
    refute_nil Jekyll::DatabaseTables::VERSION
    assert_match(/\A\d+\.\d+\.\d+\z/, Jekyll::DatabaseTables::VERSION)
  end

  def test_version_is_frozen
    assert Jekyll::DatabaseTables::VERSION.frozen?
  end
end
