# frozen_string_literal: true

require 'forwardable'

module SourceMonitor
  module Gerrit
    # A Class that represents a Gerrit Patch-set
    # https://gerrit-review.googlesource.com/Documentation/concept-patch-sets.html
    class Patchset
      extend Forwardable

      def_delegators :identifier, :change_id, :revision_id
      def_delegators :changes, :list_files, :get_content

      # @param [SourceMonitor::Gerrit::Identifier] identifier
      # @param [SourceMonitor::Gerrit::API::Changes] changes
      def initialize(identifier, changes)
        @identifier = identifier
        @changes    = changes
      end

      # Returns all the contents of files:
      # @return [Hash{String=>String}]
      # @example
      # {
      #   'file_1.txt' => "one\ntwo\nthree\nfour\n\n",
      #   'file_2.txt' => "what\nis\ngoing\non\n\n"
      # }
      def files
        @files ||= file_names.each_with_object({}) do |file_name, storage|
          storage[file_name] = get_content(change_id, revision_id, file_name)
        end
      end

      # Returns the names of all the modified files
      # @return [Array<String>]
      # @example ['/COMMIT_MSG', 'file_1.txt', 'file_2.txt']
      def file_names
        @file_names ||= list_files(change_id, revision_id).keys
      end

      private

      attr_reader :identifier, :changes
    end
  end
end
