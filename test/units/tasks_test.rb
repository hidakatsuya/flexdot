# frozen_string_literal: true

require_relative 'test_helper'

class TasksTest < Minitest::Test
  include TestHelper

  def test_default_index_with_multiple_index
    tasks = tasks_with_multiple_indexes(default_index: nil)
    assert_nil tasks.send(:default_index)

    tasks = tasks_with_multiple_indexes(default_index: 'b')
    assert_equal tasks.send(:default_index).name, 'b'

    tasks = tasks_with_multiple_indexes(default_index: 'unknown')
    assert_raises StandardError do
      tasks.send(:default_index)
    end
  end

  def test_default_index_with_single_index
    tasks = tasks_with_single_index(default_index: nil)
    assert_equal tasks.send(:default_index).name, 'a'

    tasks = tasks_with_single_index(default_index: 'a')
    assert_equal tasks.send(:default_index).name, 'a'

    tasks = tasks_with_single_index(default_index: 'unknown')
    assert_raises StandardError do
      tasks.send(:default_index)
    end
  end

  private

  def tasks_with_multiple_indexes(default_index:)
    tasks = Flexdot::Tasks.new('.', '../dotfiles', default_index)
    stub(tasks).indexes {
      [
        Flexdot::Tasks::Index.new(filename: 'a.yml', name: 'a'),
        Flexdot::Tasks::Index.new(filename: 'b.yml', name: 'b')
      ]
    }
    tasks
  end

  def tasks_with_single_index(default_index:)
    tasks = Flexdot::Tasks.new('.', '../dotfiles', default_index)
    stub(tasks).indexes {
      [Flexdot::Tasks::Index.new(filename: 'a.yml', name: 'a')]
    }
    tasks
  end
end
