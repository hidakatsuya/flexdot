# frozen_string_literal: true

require_relative '../test_helper'

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

  def backup_dir
    dotfiles / 'backup'
  end

  def assert_link(home_file, to_dotfile:)
    assert_equal(
      dotfiles.join(to_dotfile),
      home.join(home_file).readlink
    )
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

    # Create a file with the same path as the link destination
    home.join('b.conf').write('')
    # Create an invalid link with the same path as the link destination
    home.join('c.yml').make_symlink(dotfiles.join('bbb/b.conf'))
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
