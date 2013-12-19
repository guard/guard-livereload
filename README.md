# Guard::LiveReload

[![Gem Version](https://badge.fury.io/rb/guard-livereload.png)](http://badge.fury.io/rb/guard-livereload) [![Build Status](https://travis-ci.org/guard/guard-livereload.png?branch=master)](http://travis-ci.org/guard/guard-livereload) [![Dependency Status](https://gemnasium.com/guard/guard-livereload.png)](https://gemnasium.com/guard/guard-livereload) [![Code Climate](https://codeclimate.com/github/guard/guard-livereload.png)](https://codeclimate.com/github/guard/guard-livereload) [![Coverage Status](https://coveralls.io/repos/guard/guard-livereload/badge.png?branch=master)](https://coveralls.io/r/guard/guard-livereload)

LiveReload guard allows to automatically reload your browser when 'view' files are modified.

## Support

For any support question/issue related to `livereload` please ask on support@livereload.com.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Install the gem:

``` bash
$ gem install guard-livereload
```

Add it to your Gemfile (inside development group):

``` ruby
group :development do
  gem 'guard-livereload', require: false
end
```

Add guard definition to your Guardfile by running this command:

``` bash
$ guard init livereload
```

Use [rack-livereload](https://github.com/johnbintz/rack-livereload) or install [LiveReload Safari/Chrome extension](http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-)

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme) and [rack-livereload how it works readme section](https://github.com/johnbintz/rack-livereload#readme) or [LiveReload extension usage doc](https://github.com/mockko/livereload/blob/master/README-old.md) from version 1.x

## Guardfile

You can adapt your 'view' files like you want.
Please read [Guard doc](https://github.com/guard/guard#readme) for more info about Guardfile DSL.

``` ruby
guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end
```

## Options

LiveReload guard has 6 options that you can set like this:

``` ruby
guard 'livereload', grace_period: 0.5, override_url: true do
  # ...
end
```

Available options:

``` ruby
host: '127.3.3.1'     # default '0.0.0.0'
port: '12345'         # default '35729'
apply_css_live: false # default true
override_url: false   # default false
grace_period: 0.5     # default 0 (seconds)
```

See [LiveReload configuration doc](https://github.com/mockko/livereload/blob/master/README-old.md) from version 1.x for more info about those options.

## Development

* Source hosted at [GitHub](https://github.com/guard/guard-livereload).
* Report issues and feature requests to [GitHub Issues](https://github.com/guard/guard-livereload/issues).

Pull requests are very welcome! Please try to follow these simple "rules", though:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested.
* Update the README (if applicable).
* Please **do not change** the version number.

For questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Author

[Thibaud Guillaume-Gentil](https://github.com/thibaudgg)
