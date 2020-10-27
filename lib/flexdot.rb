# frozen_string_literal: true

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.setup(target_dir:, base_dir: '.', default_index: nil)
    Tasks.new(base_dir, target_dir, default_index).install
  end
end
