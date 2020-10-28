# frozen_string_literal: true

require 'pathname'
require_relative 'installer'
require_relative 'backup'

module Flexdot
  class Tasks
    include Rake::DSL

    Index = Struct.new(:filename, :name, keyword_init: true)

    def initialize(dotfiles_dir, home_dir, default_index_name = nil)
      @default_index_name = default_index_name
      @dotfiles_dir = Pathname.new(dotfiles_dir).expand_path
      @home_dir = Pathname.new(home_dir).expand_path
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
              dotfiles_dir: dotfiles_dir,
              home_dir: home_dir
            )
            installer.install(index.filename)
          end
        end
      end

      if default_index
        desc "Install dotfiles for #{default_index.name}"
        task :install do
          Rake::Task["install:#{default_index.name}"].invoke
        end
      end
    end

    private

    attr_reader :dotfiles_dir, :home_dir

    def default_index
      @default_index ||=
        if @default_index_name
          ifnone = -> { raise "#{@default_index_name} index is not found" }
          indexes.find(ifnone) { |index| index.name == @default_index_name }
        elsif indexes.size == 1
          indexes.first
        else
          nil
        end
    end

    def indexes
      @indexes ||= Pathname.new(dotfiles_dir).glob('*.yml').map do |index_file|
        Index.new(name: index_file.basename('.*'), filename: index_file)
      end
    end
  end
end


