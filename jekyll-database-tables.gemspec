# frozen_string_literal: true

require_relative 'lib/jekyll-database-tables/version'

Gem::Specification.new do |spec|
  spec.name        = 'jekyll-database-tables'
  spec.version     = Jekyll::DatabaseTables::VERSION
  spec.authors     = ['Gustavo Aguiar']
  spec.email       = ['gdiasag@gmail.com']
  spec.summary     = 'A Jekyll plugin to render markdown tables as database-styled terminal outputs'
  spec.homepage    = 'https://github.com/gdiasag/jekyll-database-tables'
  spec.license     = 'MIT'
  spec.metadata    = { 'rubygems_mfa_required' => 'true' }

  spec.files            = Dir['lib/**/*', 'README.md']
  spec.extra_rdoc_files = Dir['README.md', 'LICENSE']
  spec.require_paths    = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'jekyll', '>= 3.9', '< 5.0'
end
