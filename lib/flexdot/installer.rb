# frozen_string_literal: true

require 'yaml'

require_relative 'console'
require_relative 'backup'
require_relative 'index'

module Flexdot
  class Installer
    def initialize(name, dotfiles_dir:, home_dir:)
      @name = name
      @dotfiles_dir = dotfiles_dir
      @home_dir = home_dir
      @backup = Backup.new
      @console = Console.new(@home_dir)
    end

    def install(index_file)
      index = Index.new(YAML.load_file(index_file.to_path))
      index.each do |dotfile_path:, home_file_path:|
        install_link(dotfile_path, home_file_path)
      end

      backup.finish!
    end

    private

    attr_reader :name, :dotfiles_dir, :home_dir, :backup, :console

    def install_link(dotfile_path, home_file_path)
      dotfile = @dotfiles_dir.join(dotfile_path).expand_path
      home_file = @home_dir.join(home_file_path, dotfile.basename).expand_path

      console.log(home_file) do |status|
        if home_file.symlink?
          if home_file.readlink == dotfile
            status.result = :already_linked
          else
            home_file.unlink
            home_file.make_symlink(dotfile.to_path)
            status.result = :link_updated
          end
        else
          if home_file.exist?
            backup.call(home_file)
            status.backuped = true
          elsif !home_file.dirname.exist?
            home_file.dirname.mkpath
          end

          home_file.make_symlink(dotfile.to_path)
          status.result = :link_created
        end
      end
    end
  end
end
