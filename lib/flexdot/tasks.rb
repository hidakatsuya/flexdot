# frozen_string_literal: true

require 'pathname'
require_relative 'installer'
require_relative 'backup'

module Flexdot
  class Tasks
    include Rake::DSL

    Index = Struct.new(:filename, :name, keyword_init: true)

    def initialize(base_dir, target_dir, default_index_name = nil)
      @default_index_name = default_index_name
      @base_dir = Pathname.new(base_dir)
      @target_dir = Pathname.new(target_dir)
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
              base_dir: base_dir,
              target_dir: target_dir
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

    attr_reader :base_dir, :target_dir

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
      @indexes ||= Pathname.new(base_dir).glob('*.yml').map do |index_file|
        Index.new(name: index_file.basename('.*'), filename: index_file)
      end
    end
  end
end


