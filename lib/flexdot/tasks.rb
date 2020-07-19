# frozen_string_literal: true

require 'pathname'
require_relative 'installer'
require_relative 'backup'

module Flexdot
  class Tasks
    include Rake::DSL

    def initialize(base_dir, target_dir)
      @base_dir = Pathname.new(base_dir)
      @target_dir = Pathname.new(target_dir)
    end

    def install
      desc 'Clear backups'
      task :clear_backups do
        Backup.clear_all
      end

      namespace :install do
        Pathname.new(base_dir).glob('*.yml') do |index_file|
          name = index_file.basename('.*')

          desc "Install dotfiles for #{name}"
          task name do
            installer = Installer.new(
              name,
              base_dir: base_dir,
              target_dir: target_dir
            )
            installer.install(index_file)
          end
        end
      end
    end

    private

    attr_reader :base_dir, :target_dir
  end
end


