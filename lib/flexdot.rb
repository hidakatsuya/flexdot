# frozen_string_literal: true

require 'rake'

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  Options = Struct.new(
    # The dotfile directory path.
    # Default: '.'.
    :dotfiles_dir,

    # Whether or not to colorize the output
    # Default: true
    :output_colorize,

    # Whether to automatically delete old backups.
    # If nil, do not delete, otherwise keep to the specified number of backups.
    # Default: nil
    :keep_max_backup_count,

    keyword_init: true
  )

  DEFAULT_OPTIONS = {
    dotfiles_dir: '.',
    output_colorize: true,
    keep_max_backup_count: nil
  }

  def self.setup(home_dir:, **options)
    opts = Options.new(DEFAULT_OPTIONS.merge(options))
    Tasks.new(home_dir, opts).install
  end
end
