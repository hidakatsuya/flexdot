# frozen_string_literal: true

require 'pathname'
require 'fileutils'

module Flexdot
  class Backup
    BASE_DIR = 'backup'

    class AlreadyFinishedError < StandardError; end

    class << self
      def clear_all
        base_dir.glob('*').each(&:rmtree)
      end

      def base_dir
        Pathname.pwd.join(BASE_DIR)
      end
    end

    def initialize
      backup_dir.mkpath unless backup_dir.exist?
      @finished = false
    end

    def call(file)
      raise AlreadyFinishedError if @finished
      FileUtils.mv(file, backup_dir)
    end

    def finish!
      backup_dir.delete if backup_dir.empty?
      @finished = true
    end

    private

    def backup_dir
      @backup_dir ||= self.class.base_dir.join(Time.now.strftime('%Y%m%d%H%M%S'))
    end
  end
end
