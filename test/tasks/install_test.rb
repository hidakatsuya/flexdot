# frozen_string_literal: true

require_relative 'test_helper'

class InstallTest < Minitest::Test
  include TestHelper

  def setup
    reset_test_dir

    # prepare outdated backup directories
    [
      Time.local(2022, 1, 1, 0, 0, 0),
      Time.local(2022, 1, 2, 0, 0, 0)
    ].each { |t| backup_dir.join(t.strftime('%Y%m%d%H%M%S')).mkpath }
  end

  def test_task
    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      link created: .arc
      link created: b.conf (backup)
      link updated: c.yml
      link created: config/ddd/d.json
    OUT
    assert_home_links
    assert_backup

    sleep 1

    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      already linked: .arc
      already linked: b.conf
      already linked: c.yml
      already linked: config/ddd/d.json
    OUT
    assert_home_links
    # The backup should not increase
    assert_backup
  end

  private

  def assert_backup
    # keep one backup by seting keep_max_backup_setting
    assert_equal 1, backup_dir.children.size

    backup = backup_dir.children.first
    assert_equal ['b.conf'], backup.children.map { |c| c.basename.to_s }
  end

  def assert_home_links
    assert_link '.arc', to_dotfile: 'group_x/aaa/.arc'
    assert_link 'b.conf', to_dotfile: 'group_x/bbb/b.conf'
    assert_link 'c.yml', to_dotfile: 'group_x/ccc/c.yml'
    assert_link 'config/ddd/d.json', to_dotfile: 'group_y/ddd/d.json'
  end
end
