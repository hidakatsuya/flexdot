# frozen_string_literal: true

module Flexdot
  class Console
    Status = Struct.new(:home_file, :result, :backuped)

    def initialize(dotfiles_dir)
      @dotfiles_dir = dotfiles_dir
    end

    def log(home_file)
      status = Status.new(home_file)
      yield(status)
      puts message_for(status)
    end

    private

    attr_reader :dotfiles_dir

    def message_for(status)
      [].tap { |msg|
        msg << "[#{status.result}]"
        msg << status.home_file.relative_path_from(dotfiles_dir)
        msg << '(backup)' if status.backuped
      }.join(' ')
    end
  end
end
