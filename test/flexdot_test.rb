# frozen_string_literal: true

require 'test_helper'

class FlexdotTest < Minitest::Test
  include TestHelper

  def setup
    reset_test_dir
  end

  def test_task
    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      [link_created] .arc
      [link_created] b.conf (backup)
      [link_created] config/ccc/c.json
    OUT

    stdout = run_rake 'install:example'

    assert_equal <<~OUT, stdout
      [already_linked] .arc
      [already_linked] b.conf
      [already_linked] config/ccc/c.json
    OUT
  end

  def teardown
    reset_test_dir
  end
end
