# frozen_string_literal: true

require_relative 'test_helper'

class ListTest < Minitest::Test
  include TestHelper

  def test_task
    stdout = run_rake '-T'

    assert_equal <<~OUT, stdout
      rake clear_backups    # Clear backups
      rake install          # Install dotfiles for example
      rake install:example  # Install dotfiles for example
    OUT
  end
end
