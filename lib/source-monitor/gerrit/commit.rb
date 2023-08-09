# frozen_string_literal: true

module SourceMonitor
  module Gerrit
    # Class representing a Gerrit Commit, and it can point to its parent.
    class Commit
      extend Forwardable

      attr_reader :projects

      def_delegators :identifier, :project, :revision_id
      def_delegators :projects, :get_commit

      # @param [SourceMonitor::Gerrit::Identifier] identifier
      # @param [SourceMonitor::Gerrit::API::Projects] projects
      def initialize(identifier, projects)
        @identifier = identifier
        @projects   = projects
      end

      def change_id
        @change_id ||= commit['message'].match(/\bChange-Id: (.+)/)[1]
      end

      def parent
        @parent ||= resolve_parent
      end

      private

      def parent_identifier(parent_revision_id)
        SourceMonitor::Gerrit::Identifier.new(revision_id: parent_revision_id, project: project)
      end

      def resolve_parent
        parents = commit['parents']
        raise StandardError, 'More than 2 commit parents!' if parents.size > 1

        parents.first.tap do |parent|
          self.class.new(parent_identifier(parent['commit']), projects)
        end
      end

      def commit
        @commit ||= get_commit(project, revision_id)
      end
    end
  end
end
