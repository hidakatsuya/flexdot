# frozen_string_literal: true

require 'pathname'
require_relative 'installer'
require_relative 'backup'

module Flexdot
  class Tasks
    include Rake::DSL

    Index = Struct.new(:filename, :name, keyword_init: true)

    def initialize(home_dir, options)
      @home_dir = Pathname.new(home_dir).expand_path
      @dotfiles_dir = Pathname.new(options.dotfiles_dir).expand_path
      @options = options
    end

    def install
      desc 'Clear backups'
      task :clear_backups do
        Backup.clear_all
      end

      namespace :install do
        indexes.each do |index|
          desc "Install dotfiles for #{index.name}"
          task index.name do
            installer = Installer.new(
              index.name,
              home_dir,
              dotfiles_dir,
              options
            )
            installer.install(index.filename)
          end
        end
      end
    end

    private

    attr_reader :home_dir, :dotfiles_dir, :options

    def indexes
      @indexes ||= Pathname.new(dotfiles_dir).glob('*.yml').map do |index_file|
        Index.new(name: index_file.basename('.*').to_s, filename: index_file)
      end
    end
  end
end


