## 2.0.0

### Breaking Changes

v1.0.x

```ruby
# Rakefile
Flexdot.install_tasks(
  target_dir: '/home/username',
  base_dir: '.'
)
```

v2.0.0

```ruby
Flexdot.setup(
  home_dir: '/home/username',
  dotfiles_dir: '.'
)
```

### Enchancements

- Add `default_index` option fixes #2
- Option renaming and simplification by default value

Please refer to README.md for details.
