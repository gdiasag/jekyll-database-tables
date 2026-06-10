# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_tasks'

require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
end

task default: 'test'
