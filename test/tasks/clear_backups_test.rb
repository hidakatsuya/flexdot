# frozen_string_literal: true

require_relative 'test_helper'

class ClearBackupsTest < Minitest::Test
  include TestHelper

  def setup
    reset_test_dir

    3.times do |t|
      backup = backup_dir.join(Time.now.strftime('%Y%m%d%H%M%S'))
      backup.mkpath
      backup.join('foo.conf').write('foo')
      backup.join('bar.conf').write('bar')
    end
  end

  def test_task
    refute backup_dir.empty?

    run_rake 'clear_backups'

    assert backup_dir.empty?
  end

  private

  def backup_dir
    dotfiles / 'backup'
  end
end
