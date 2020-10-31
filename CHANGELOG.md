## 2.0.0

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

Not that If the `dotfiles_dir` option is `'.'` (current directory) , you can omit it.

Then, update flexdot to v2.0.0 and you're done.

    $ bundle update flexdot

### Breaking Changes

- Change the syntax of configuration in the `Rakefile`

### Enchancements

- Add `default_index` option fixes #2
- Option renaming and simplification by default value


