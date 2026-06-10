# frozen_string_literal: true

require 'jekyll'

module Jekyll
  module DatabaseTables
    autoload :VERSION,       'jekyll-database-tables/version'
    autoload :Table,         'jekyll-database-tables/table'
    autoload :Row,           'jekyll-database-tables/table'
    autoload :Parser,        'jekyll-database-tables/parser'
    autoload :Formatter,     'jekyll-database-tables/formatters'
    autoload :PsqlFormatter, 'jekyll-database-tables/formatters'
    autoload :Converter,     'jekyll-database-tables/converter'
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  doc.content = Jekyll::DatabaseTables::Converter.call(doc.content)
end
