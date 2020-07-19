# frozen_string_literal: true

require 'pathname'
require_relative '../lib/flexdot'

require 'minitest/autorun'

module TestHelper
  def root
    @root ||= Pathname.new(__dir__)
  end

  def home
    root / 'home'
  end

  def dotfiles
    home / 'dotfiles'
  end

  def reset_test_dir
    reset_home
    reset_dotfiles
  end

  def reset_home
    home.each_child do |path|
      next if path == dotfiles

      if path.directory?
        FileUtils.rm_rf(path.to_s)
      else
        path.delete
      end
    end

    home.join('b.conf').write('')
  end

  def reset_dotfiles
    FileUtils.rm_rf(dotfiles.join('backup').to_s)
  end

  def run_rake(task)
    Dir.chdir(dotfiles.to_path) do
      `rake #{task}`
    end
  end
end
