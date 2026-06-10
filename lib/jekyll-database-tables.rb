# frozen_string_literal: true

require 'jekyll'

require 'jekyll-database-tables/version'
require 'jekyll-database-tables/table'
require 'jekyll-database-tables/parser'
require 'jekyll-database-tables/formatters'
require 'jekyll-database-tables/converter'

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  formatter = doc.site.config.dig('jekyll_database_tables', 'formatter') || 'psql'

  doc.content = Jekyll::DatabaseTables::Converter.call(doc.content, formatter:)
end
