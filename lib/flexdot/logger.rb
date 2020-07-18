# frozen_string_literal: true

module Flexdot
  class Logger
    Status = Struct.new(:target_file, :result, :backuped)

    def initialize(target_dir)
      @target_dir = target_dir
    end

    def log(target_file)
      status = Status.new(target_file)
      yield(status)
      puts message_for(status)
    end

    private

    attr_reader :target_dir

    def message_for(status)
      [].tap { |msg|
        msg << "[#{status.result}]"
        msg << status.target_file.relative_path_from(target_dir)
        msg << '(backup)' if status.backuped
      }.join(' ')
    end
  end
end
