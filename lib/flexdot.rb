# frozen_string_literal: true

require 'rake'

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.setup(home_dir:, dotfiles_dir: '.', output_colorize: true, keep_max_backup_count: nil)
    Tasks.new(dotfiles_dir, home_dir, output_colorize, keep_max_backup_count).install
  end
end
