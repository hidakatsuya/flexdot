# Flexdot

[![Gem Version](https://badge.fury.io/rb/flexdot.svg)](https://badge.fury.io/rb/flexdot)
[![Test](https://github.com/hidakatsuya/flexdot/workflows/Test/badge.svg?branch=master)](https://github.com/hidakatsuya/flexdot/actions?query=workflow%3ATest)

A Flexible and Rake based dotfile manager.

## Getting Started

### Prerequisite

Ruby 2.7+

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

## Example

This example is my actual dotfile environment.

I have two working environments, macOS and ubuntu. The dotfiles in these environments are slightly different, so each dotfile is separated.

### Directory Structure

```
$HOME/dotfiles
├── common
│   ├── bin
│   │   ├── git-delete-other-branches
│   │   └── git-reset-and-clean
│   ├── git
│   │   └── ignore
│   ├── rubygems
│   │   └── .gemrc
│   └── vim
│       └── .vimrc
├── macOS
│   ├── bash
│   │   ├── .bash_profile
│   │   └── .bashrc
│   ├── git
│   │   └── .gitconfig
│   ├── karabiner
│   │   └── tab-emulation.json
│   └── vscode
│       ├── keybindings.json
│       └── settings.json
├── ubuntu
│   ├── bash
│   │   └── .bashrc
│   ├── bin
│   │   ├── upgrade-ghcli
│   │   ├── utils
│   │   ├── x-copy
│   │   └── x-open
│   ├── git
│   │   └── .gitconfig
│   ├── vscode
│   │   ├── keybindings.json
│   │   └── settings.json
│   └── xkeysnail
│       ├── config.py
│       ├── debug.sh
│       ├── restart.sh
│       ├── start.sh
│       └── stop.sh
├── macOS.yml
├── ubuntu.yml
└── Rakefile
```

### Rakefile

```ruby
require 'flexdot'

Flexdot.setup(
  home_dir: '..'
)

# You can execute `install:macOS` when you run `rake` command
# with no arguments by defining it as follows:
task default: 'install:macOS'
```

### Available Commands

When you run the `rake -T` command in that directory structure, you should have two installation commands available:

    $ rake -T
    rake clear_backups   # Clear all backups
    rake install:macOS   # Install dotfiles for macOS
    rake install:ubuntu  # Install dotfiles for ubuntu

### Dotfile Index File

`macOS.yml` and `ubuntu.yml` are for setting the link destination of dotfile. dotfile will be installed according to its setting.

#### macOS.yml

For example, `common -> bin -> git-delete-other-branchs` is `$HOME/dotfiles/common/bin/git-delete-other-branches`.
And the value `bin` means `$HOME/bin` directory.

So this defines linking `$HOME/dotfiles/common/bin/git-delete-other-branches` to `$HOME/bin/git-delete-other-branches`.


```yml
common:
  bin:
    git-delete-other-branches: bin
    git-reset-and-clean: bin
  git:
    ignore: .config/git
  rubygems:
    .gemrc: .
  vim:
    .vimrc: .

macOS:
  bash:
    .bash_profile: .
    .bashrc: .
  git:
    .gitconfig: .
  karabiner:
    tab-emulation.json: .config/karabiner/assets/complex_modifications
  vscode:
    keybindings.json: Library/Application Support/Code/User
    settings.json: Library/Application Support/Code/User
```

#### ubuntu.yml

```yml
common:
  bin:
    git-delete-other-branchs: bin
    git-reset-and-clean: bin
  git:
    ignore: .config/git
  rubygems:
    .gemrc: .
  vim:
    .vimrc: .

ubuntu:
  bash:
    .bashrc: .
  bin:
    upgrade-ghcli: bin
    utils: bin
    x-copy: bin
    x-open: bin
  git:
    .gitconfig: .
  vscode:
    keybindings.json: .config/Code/User
    settings.json: .config/Code/User
  xkeysnail:
    config.py: .xkeysnail
    debug.sh: .xkeysnail
    restart.sh: .xkeysnail
    start.sh: .xkeysnail
    stop.sh: .xkeysnail
```

### Installing dotfiles for macOS

    $ rake

Or,

    $ rake install:macOS

The following is the output result:

```
already linked: bin/git-delete-other-branches
already linked: bin/git-reset-and-clean
already linked: .config/git/ignore
already linked: .gemrc
already linked: .vimrc
link created: .bash_profile (backup)
link created: .bashrc (backup)
link created: .gitconfig (backup)
link created: .config/karabiner/assets/complex_modifications/tab-emulation.json (backup)
link created: Library/Application Support/Code/User/keybindings.json (backup)
link created: Library/Application Support/Code/User/settings.json (backup)
```

`already_linked` means skipped because `bin/git-delete-other-branches` is already linked. `link_created` means the link was created.
Also, `(backup)` means that a file exists in the link path and that file was backed up to `$HOME/dotfiles/backup/YYYYMMDDHHIISS/filename`.

### Misc

You can clear all backups in `$HOME/dotfiles/backup/YYYYMMDDHHIISS` to run `rake clear_backups`.

    $ rake clear_backups

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexdot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hidakatsuya/flexdot/blob/master/CODE_OF_CONDUCT.md).
