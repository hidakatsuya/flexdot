# frozen_string_literal: true

module Flexdot
  class Index
    def initialize(index)
      @index = index
    end

    def each(&block)
      index.each do |root, descendants|
        fetch_descendants(descendants, paths: [root], &block)
      end
    end

    private

    attr_reader :index

    def fetch_descendants(descendants, paths:, &block)
      descendants.each do |k, v|
        dotfile_path = paths + [k]
        case v
        when String
          block.call(dotfile_path: File.join(*dotfile_path), target_path: v)
        when Hash
          fetch_descendants(v, paths: dotfile_path, &block)
        else
          raise ArgumentError, v
        end
      end
    end
  end
end
