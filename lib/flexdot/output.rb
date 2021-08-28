# frozen_string_literal: true

require 'paint'

module Flexdot
  class Output
    Status = Struct.new(:home_file, :result, :backuped)

    def initialize(dotfiles_dir, colorize: true)
      @dotfiles_dir = dotfiles_dir
      @colorize = colorize
    end

    def log(home_file)
      status = Status.new(home_file)
      yield(status)
      puts message_for(status)
    end

    private

    attr_reader :dotfiles_dir

    def message_for(status)
      result_color =
        case status.result
        when :already_linked then :gray
        when :link_updated   then :yellow
        when :link_created   then :green
        else :default
        end

      msg = []
      msg << paint("#{status.result.to_s.gsub('_', ' ')}:", result_color)
      msg << status.home_file.relative_path_from(dotfiles_dir)
      msg << '(backup)' if status.backuped
      msg.join(' ')
    end

    def paint(string, *colors)
      colorize? ? Paint[string, *colors] : string
    end

    def colorize?
      @colorize
    end
  end
end
