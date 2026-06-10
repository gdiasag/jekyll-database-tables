# jekyll-database-tables

Render Markdown pipe tables as databse-styled terminal output inside `<pre>` blocks for [Jekyll](https://jekyllrb.com/).

## Installation

Install via RubyGems:

``` bash
gem install jekyll-database-tables
```

Or add it to your `Gemfile`:

``` ruby
gem 'jekyll-database-tables'
```

Then enable the plugin in `_config.yml`:

``` yaml
plugins:
  - jekyll-database-tables
```

## Usage

Write a standard GFM pipe table in any page or document:

``` markdown
| Name  | Age |
|-------|-----|
| Alice | 30  |
| Bob   | 25  |
```

The plugin replaces it with a `<pre class="[db]-table">` block during the build:

``` html
Name  | Age
------+----
Alice | 30
Bob   | 25
```

Content inside fenced code blocks is never processed, so example tables in documentation stay intact.

### Configuration

All options go under the `jekyll_database_tables` key in `_config.yml`:

``` yaml
jekyll_database_tables:
  formatter: psql
```

#### Formatters

- **Default (`psql`)**: PostgreSQL-styled terminal output with space-padded columns separated by `|` and a `-+-` divider.

Custom formatters can also be provided (see [Development](#development)).

## Development

### Nix

``` bash
git clone https://github.com/gdiasag/jekyll-database-tables
cd jekyll-database-tables
nix develop
rake test
```

Starting a shell with the build environment provided in `flake.nix` provides you with Ruby, Bundler, and all gem dependencies pinned to exact versions from the lock file, so no `bundle install` needed. Gem executables (e.g. `rake` and `rubocop`) are on `PATH` directly.

### Others

Requires [Ruby] v3.2+ and [Bundler] v2.7+.

``` bash
git clone https://github.com/gdiasag/jekyll-database-tables
cd jekyll-database-tables
bundle install
bundle exec rake test
```

[Ruby]: https://www.ruby-lang.org/en
[Bundler]: https://bundler.io

### Writing a custom formatter

Create a subclass of `Jekyll::DatabaseTables::Formatter` implementing `#render`, `#format_row`, and `#separator`. Then register it in `Jekyll::DatabaseTables::Converter#formatter_instance`:

``` ruby
class CustomFormatter < Jekyll::DatabaseTables::Formatter
  include Formatter::Helpers

  def render(table, title: nil)
    # ...
  end

  def format_row(cells, widths)
    # ...
  end

  def separator(widths)
    # ...
  end
end
```

Users select it via `_config.yml`:

``` yaml
jekyll_database_tables:
  formatter: custom
```
