# frozen_string_literal: true

require 'rake'

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.setup(home_dir:, dotfiles_dir: '.', output_colorize: true)
    Tasks.new(dotfiles_dir, home_dir, output_colorize).install
  end
end
