# frozen_string_literal: true

require 'rake'

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.setup(home_dir:, dotfiles_dir: '.')
    Tasks.new(dotfiles_dir, home_dir).install
  end
end
