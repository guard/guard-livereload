#### :warning: :warning: :warning: Security Vulnerability: please upgrade to v2.5.2 - [details here ](https://github.com/guard/guard-livereload/issues/159). (Credits: [Michael Coyne](https://github.com/mikeycgto))

# Guard::LiveReload

[![Gem Version](https://badge.fury.io/rb/guard-livereload.svg)](http://badge.fury.io/rb/guard-livereload) [![Build Status](https://travis-ci.org/guard/guard-livereload.svg?branch=master)](http://travis-ci.org/guard/guard-livereload) [![Dependency Status](https://gemnasium.com/guard/guard-livereload.svg)](https://gemnasium.com/guard/guard-livereload) [![Code Climate](https://codeclimate.com/github/guard/guard-livereload.svg)](https://codeclimate.com/github/guard/guard-livereload) [![Coverage Status](https://coveralls.io/repos/guard/guard-livereload/badge.svg?branch=master)](https://coveralls.io/r/guard/guard-livereload)
[![Join the chat at https://gitter.im/guard/guard-livereload](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/guard/guard-livereload?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


LiveReload guard allows to automatically reload your browser when 'view' files are modified.

## Support

##### :warning: Guard::LiveReload is looking for a new maintainer. Please [contact me](mailto:thibaud@thibaud.gg) if you're interested.

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
  gem 'guard-livereload', '~> 2.5', require: false
end
```

Add guard definition to your Guardfile by running this command:

``` bash
$ guard init livereload
```

And to get everything running in the browser, use [rack-livereload](https://github.com/johnbintz/rack-livereload) or install the [LiveReload Safari/Chrome/Firefox extension](http://livereload.com/extensions#installing-sections).

## Usage
Run the server in the directory you want to watch:

    % livereload

You should see something like this:

![](https://github.com/mockko/livereload/raw/master/docs/images/livereload-server-running.png)

Now, if you are using Safari, right-click the page you want to be livereload'ed and choose “Enable LiveReload”:

![](https://github.com/mockko/livereload/raw/master/docs/images/safari-context-menu.png)

If you are using Chrome, just click the toolbar button (it will turn green to indicate that LiveReload is active).

For a quick start, [check out the wiki](https://github.com/guard/guard-livereload/wiki/Usage).

If you're using Rails or Rack based apps, check out [rack-livereload how it works readme section](https://github.com/johnbintz/rack-livereload#readme).

For info about Guard and it's plugins, see [Guard usage doc](https://github.com/guard/guard#readme)

For more info about LiveReload extensions, see [LiveReload extension usage doc](https://github.com/mockko/livereload/blob/master/README-old.md) from version 1.x


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
notify: true          # default false
host: '127.3.3.1'     # default '0.0.0.0'
port: '12345'         # default '35729'
apply_css_live: false # default true
override_url: false   # default false
grace_period: 0.5     # default 0 (seconds)
js_template: './my_livereload.js.erb' # default is livereload.js.erb from gem
```

Additional custom JS template options (see livereload.js.erb for details):
``` ruby
js_apple_webkit_extra_wait_time: 50 # default is 5 (see issue #123)
js_default_extra_wait_time: 100 # default is 200
```


`notify` uses Guard's [system notifications](https://github.com/guard/guard/wiki/System-notifications).
See [LiveReload configuration doc](https://github.com/mockko/livereload/blob/master/README-old.md) from version 1.x for more info about other options.

## Troubleshooting

To work out what's wrong and where, just follow this easy guide: https://github.com/guard/guard-livereload/wiki/Troubleshooting

### Other issues:

##### 1. "hw.ncpu" is an unknown key.

Solution: just upgrade the `listen` gem to '3.x' (Listen is used by Guard).

(Details: https://github.com/guard/guard-livereload/issues/134)

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
