# frozen_string_literal: true

require 'yaml'

require_relative 'console'
require_relative 'backup'
require_relative 'index'

module Flexdot
  class Installer
    def initialize(name, base_dir:, target_dir:)
      @name = name
      @base_dir = base_dir
      @target_dir = target_dir
      @backup = Backup.new
      @console = Console.new(@target_dir)
    end

    def install(index_file)
      index = Index.new(YAML.load_file(index_file.to_path), base_dir)

      index.each do |dotfile_path:, target_path:|
        dotfile = dotfile_path.expand_path
        target_file = target_dir.join(target_path, dotfile.basename).expand_path

        install_link(dotfile, target_file)
      end
    end

    private

    attr_reader :name, :base_dir, :target_dir, :backup, :console

    def install_link(dotfile, target_file)
      console.log(target_file) do |status|
        if target_file.symlink?
          if target_file.readlink == dotfile
            status.result = :already_linked
          else
            target_file.unlink
            target_file.make_symlink(dotfile.to_path)
            status.result = :link_updated
          end
        else
          if target_file.exist?
            backup.call(target_file)
            status.backuped = true
          elsif !target_file.dirname.exist?
            target_file.dirname.mkpath
          end

          target_file.make_symlink(dotfile.to_path)
          status.result = :link_created
        end
      end
    end
  end
end
