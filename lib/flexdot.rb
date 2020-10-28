# frozen_string_literal: true

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.setup(home_dir:, dotfiles_dir: '.', default_index: nil)
    Tasks.new(dotfiles_dir, home_dir, default_index).install
  end
end
