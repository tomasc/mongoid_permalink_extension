# Mongoid Permalink Extension

[![Build Status](https://travis-ci.org/tomasc/mongoid_permalink_extension.svg)](https://travis-ci.org/tomasc/mongoid_permalink_extension) [![Coverage Status](https://img.shields.io/coveralls/tomasc/mongoid_permalink_extension.svg)](https://coveralls.io/r/tomasc/mongoid_permalink_extension)

A [Mongoid](https://github.com/mongoid/mongoid) field extension that stores any String as a permalink slug.

* converts spaces to hyphens
* converts to camel case
* converts all dashes to hyphens
* remove non-alphanumeric characters
* removes accents

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_permalink_extension'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_permalink_extension

## Usage

Add to Mongoid models as:

    field :permalink, type: MongoidPermalinkExtension::Permalink
    
Produces slugs in the form of:

    A-Hard-Days-Night

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
