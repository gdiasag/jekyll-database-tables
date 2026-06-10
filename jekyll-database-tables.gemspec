# frozen_string_literal: true

require_relative 'lib/jekyll-database-tables/version'

Gem::Specification.new do |s|
  s.name        = 'jekyll-database-tables'
  s.summary     = 'Render markdown tables as database-style terminal output for Jekyll.'
  s.description = <<~DESC
    A Jekyll plugin that transforms markdown tables into PostgreSQL-style
    ASCII tables wrapped in `<pre>` tags, giving documentation pages the
    look and feel of a terminal database client.
  DESC

  s.version     = Jekyll::DatabaseTables::VERSION
  s.authors     = ['Gustavo Dias']
  s.email       = ['gustavodiasag@gmail.com']

  s.homepage    = 'https://github.com/gustavodiasag/jekyll-database-tables'
  s.licenses    = ['MIT']

  s.metadata    = {
    'source_code_uri' => 'https://github.com/gustavodiasag/jekyll-database-tables'
  }

  s.files = Dir['lib/**/*'].push('LICENSE')
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 3.1'

  s.add_dependency 'jekyll', '>= 3.9', '< 5.0'
end
