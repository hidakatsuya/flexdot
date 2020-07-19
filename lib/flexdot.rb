# frozen_string_literal: true

require_relative 'flexdot/version'
require_relative 'flexdot/tasks'

module Flexdot
  def self.install_tasks(base_dir:, target_dir:)
    Tasks.new(base_dir, target_dir).install
  end
end
