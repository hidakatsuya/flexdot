## 3.0.0

### Breaking Changes

Revert 'Add default_index option #2'. Please follow the instructions below to migrate:

First, modify your Rakefile as follows:

```diff
require 'flexdot'

Flexdot.setup(
+   home_dir: '..'
-   home_dir: '..',
-   default_index: 'macOS'
)

+ task default: 'install:macOS'
```

Then, update flexdot:

```
$ bundle update flexdot
```

Now you can run the following command to install the default index dotfiles:

```
$ rake
```

## 2.0.0

### Breaking Changes

- Change the syntax of configuration in the `Rakefile`

### Enchancements

- Add `default_index` option fixes #2
- Option renaming and simplification by default value

### Migrating from v1.0.x

First, you need to rewrite the `Rakefile` configuration to the v2.0.0 syntax.

```ruby
# v1.0.x
Flexdot.install_tasks(
  target_dir: '/home/username',
  base_dir: '.'
)
```

```ruby
# v2.0.0
Flexdot.setup(
  home_dir: '/home/username',
  dotfiles_dir: '.'
)
```

Note that If the `dotfiles_dir` option is `'.'` (current directory) , you can omit it.

Then, update flexdot to v2.0.0 and you're done.

    $ bundle update flexdot
