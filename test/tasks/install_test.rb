# frozen_string_literal: true

require_relative 'test_helper'

class InstallTest < Minitest::Test
  include TestHelper

  def setup
    reset_test_dir
  end

  def test_task
    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      [link_created] .arc
      [link_created] b.conf (backup)
      [link_updated] c.yml
      [link_created] config/ddd/d.json
    OUT
    assert_home_links
    assert_backup

    sleep 1

    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      [already_linked] .arc
      [already_linked] b.conf
      [already_linked] c.yml
      [already_linked] config/ddd/d.json
    OUT
    assert_home_links
    # The backup should not increase
    assert_backup
  end

  private

  def assert_backup
    backup = backup_dir.children.first

    assert_equal 1, backup_dir.children.size
    assert_equal ['b.conf'], backup.children.map { |c| c.basename.to_s }
  end

  def assert_home_links
    assert_link '.arc', to_dotfile: 'group_x/aaa/.arc'
    assert_link 'b.conf', to_dotfile: 'group_x/bbb/b.conf'
    assert_link 'c.yml', to_dotfile: 'group_x/ccc/c.yml'
    assert_link 'config/ddd/d.json', to_dotfile: 'group_y/ddd/d.json'
  end
end
