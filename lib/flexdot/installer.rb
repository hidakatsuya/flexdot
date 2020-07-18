# frozen_string_literal: true


module Flexdot
  class Installer
    def initialize(name, target_dir: nil)
      @name = name
      @base_dir = Pathname.pwd
      @target_dir = target_dir || base_dir.join('..')
      @backup = Backup.new
      @logger = Logger.new(@target_dir)
    end

    def install(index_file)
      index = Index.new(YAML.load_file(index_file.to_path))
      index.each do |dotfile_path:, target_path:|
        install_link(dotfile_path, target_path)
      end
    end

    private

    attr_reader :name, :base_dir, :target_dir, :backup, :logger

    def install_link(dotfile_path, target_path)
      dotfile = @base_dir.join(dotfile_path).expand_path
      target_file = @target_dir.join(target_path, dotfile.basename).expand_path

      logger.log(target_file) do |status|
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
          end

          target_file.make_symlink(dotfile.to_path)
          status.result = :link_created
        end
      end
    end
  end
end
