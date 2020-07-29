# frozen_string_literal: true

module Flexdot
  class Index
    def initialize(index, base_dir)
      @index = index
      @base_dir = base_dir
    end

    def each(&block)
      @index.each do |key, value|
        DirectoryNode.new(key, value, @base_dir).call(&block)
      end
    end

    private

    class Node
      def self.match?(_key, _value)
        raise NotImplementedError
      end

      def initialize(key, value, directory)
        @key = key
        @value = value
        @directory = directory
      end

      def call(&block)
        raise NotImplementedError
      end

      private

      def path
        @directory.join(@key)
      end
    end

    class DirectoryNode < Node
      def self.match?(_key, value)
        value.is_a?(Hash)
      end

      def call(&block)
        all_files_node = detect_all_files_node

        if all_files_node
          all_files_node.call(&block)
          warn '[warn] some links were ignored due to the inclusion of "*".' if children.size > 1
        else
          children.each do |k, v|
            node(k, v).call(&block)
          end
        end
      end

      private

      def children
        @value
      end

      def detect_all_files_node
        node_value = children.find { |k, v| AllFilesNode.match?(k, v) }
        node_value ? AllFilesNode.new(*node_value, path) : nil
      end

      def node(key, value)
        node_class = [
          DirectoryNode,
          FileNode
        ].find { |klass| klass.match?(key, value) }

        raise ArgumentError, 'Invalid node' unless node_class

        node_class.new(key, value, path)
      end
    end

    class FileNode < Node
      def self.match?(key, value)
        value.is_a?(String) && key != '*'
      end

      def call(&block)
        block.call(dotfile_path: path, target_path: target_path)
      end

      private

      def target_path
        @value
      end
    end

    class AllFilesNode < FileNode
      def self.match?(key, value)
        value.is_a?(String) && key == '*'
      end

      def call(&block)
        filenames.each do |filename|
          FileNode.new(filename, target_path, @directory).call(&block)
        end
      end

      private

      def filenames
        @directory.children.select(&:file?).map(&:basename)
      end
    end
  end
end
