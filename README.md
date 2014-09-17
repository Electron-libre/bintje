[![Build Status](https://travis-ci.org/Electron-libre/bintje.svg?branch=master)](https://travis-ci.org/Electron-libre/bintje)
[![Code Climate](https://codeclimate.com/github/Electron-libre/bintje.png)](https://codeclimate.com/github/Electron-libre/bintje)
[![Coverage Status](https://coveralls.io/repos/Electron-libre/bintje/badge.png?branch=master)](https://coveralls.io/r/Electron-libre/bintje?branch=master)
[![Security Status](https://hakiri.io/github/Electron-libre/bintje/master.svg)](https://hakiri.io/github/Electron-libre/bintje/master.svg)


# Bintje

Provides few methods to access OpenObject's framework models and methods through xmlrpc.

## Installation

Add this line to your application's Gemfile:

    gem 'bintje'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bintje

## Usage

Include the OpenObject module into a class :

    class ReceiverModel
        include OpenObject
    end

If the OpenObject model name is not you class name underscored, then set the OpenObject model name

    class ReceiverModel
        include OpenObject
        set_open_object_model "another_name"
    end

Then you can request OpenObject models with standard CRUD methods ...
See ``spec/reciever_model_spec.rb`` for more details on how it works

## Generate documentation

1. install yard gem
2. yard doc
3. yard graph --dependencies --empty-mixins --full | dot -T svg -o diagram.svg
4. firefox doc/index.html
5. firefox doc/diagram.svg

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
