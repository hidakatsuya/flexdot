# Flexdot

[![Gem Version](https://badge.fury.io/rb/flexdot.svg)](https://badge.fury.io/rb/flexdot)
[![Test](https://github.com/hidakatsuya/flexdot/workflows/Test/badge.svg?branch=master)](https://github.com/hidakatsuya/flexdot/actions?query=workflow%3ATest)

A Flexible and Rake based dotfile manager.

## Getting Started

### Prerequisite

Ruby 3.2 or later

### Installing

Create the following directory structure:

```
$HOME/
├── dotfiles/
:
```

Create a `Gemfile` to install Flexdot:

    $ cd $HOME/dotfiles
    $ bundle init

Add this line to the `Gemfile`:

```ruby
gem 'flexdot'
```

Or install it yourself as:

    $ gem install flexdot

Then, create a `$HOME/dotfiles/Rakefile` with the following codes:

```ruby
require 'flexdot'

Flexdot.setup(
  home_dir: '/home/username',

  # (optional)
  # The dotfile directory path.
  # Default '.'.
  dotfiles_dir: '.'

  # (optional)
  # Whether or not to colorize the output
  # Default: true
  output_colorize: true

  # (optional)
  # Whether to automatically delete old backups.
  # If nil, do not delete, otherwise keep to the specified number of backups.
  # Default: nil
  keep_max_backup_count: 10
)
```

It is recommended that you add the Rakefile to `gitignore`:

```
# .gitignore
Rakefile
```

Finally, run `rake -T` in the `$HOME/dotfiles` and make sure that the output is as follows:

    $ rake -T
    rake clear_backups

## Usage

See [doc/example.md](doc/example.md)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexdot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hidakatsuya/flexdot/blob/master/CODE_OF_CONDUCT.md).
