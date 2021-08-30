# Capistrano::goenv

[goenv](https://github.com/creationix/goenv) support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.1'
gem 'capistrano-goenv', require: false
```

And then execute:

    $ bundle install

## Usage

Require in `Capfile` to use the default task:

```ruby
require 'capistrano/goenv'
```

Configurable options:

```ruby
set :goenv_type, :user # or :system, depends on your goenv setup
set :goenv_go_version, '1.14.0'
set :goenv_map_bins, %w{go}
```

If your goenv is located in some custom path, you can use `goenv_custom_path` to set it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
