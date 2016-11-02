# RuboCop::Gemfile

Code style checking for Gemfile, as an extension to [Rubocop](https://github.com/bbatsov/rubocop)

[![Gem Version](https://badge.fury.io/rb/rubocop-gemfile.svg)](https://badge.fury.io/rb/rubocop-gemfile)
[![Build Status](https://travis-ci.org/sue445/rubocop-gemfile.svg?branch=master)](https://travis-ci.org/sue445/rubocop-gemfile)
[![Code Climate](https://codeclimate.com/github/sue445/rubocop-gemfile/badges/gpa.svg)](https://codeclimate.com/github/sue445/rubocop-gemfile)
[![Coverage Status](https://coveralls.io/repos/github/sue445/rubocop-gemfile/badge.svg?branch=master)](https://coveralls.io/github/sue445/rubocop-gemfile?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/sue445/rubocop-gemfile.svg)](https://gemnasium.com/github.com/sue445/rubocop-gemfile)

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'rubocop-gemfile', require: false
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop-gemfile

## Usage

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```
require: rubocop-gemfile
```

## The Cops
see these.

* [config/default.yml](config/default.yml)
* [lib/rubocop/cop/gemfile/](lib/rubocop/cop/gemfile/)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sue445/rubocop-gemfile.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

