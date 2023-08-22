# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'erb'

module SourceMonitor
  module Gerrit
    # Represents values that are needed to identify a single change in Gerrit.
    # These are change_id, project, revision id or branch.
    class Identifier
      DEFAULT_REVISION_ID = 'current'

      include ERB::Util

      # @param [String, nil] change_id_nr
      # @param [String] revision_id
      # @param [String, nil] project
      # @param [String, nil] branch
      def initialize(change_id_nr: nil, revision_id: DEFAULT_REVISION_ID, project: nil, branch: nil)
        @change_id_nr_raw = url_encode(change_id_nr).presence
        @revision_id_raw  = url_encode(revision_id).presence
        @project_raw      = url_encode(project).presence
        @branch_raw       = url_encode(branch).presence
      end

      def change_id_nr
        @change_id_nr ||= resolve_change_id_nr
      end

      # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#revision-id
      def revision_id
        @revision_id ||= resolve_revision_id
      end

      def project
        @project ||= resolve_project
      end

      # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#change-id
      def change_id
        @change_id ||= resolve_change_id
      end

      def branch
        @branch ||= resolve_branch
      end

      private

      attr_reader :change_id_nr_raw, :revision_id_raw, :project_raw, :branch_raw

      def resolve_change_id_nr
        raise(StandardError, '"change_id_nr" was not defined') unless change_id_nr_raw

        change_id_nr_raw
      end

      def resolve_revision_id
        raise(StandardError, '"revision_id" was not defined') unless revision_id_raw

        revision_id_raw
      end

      def resolve_project
        raise(StandardError, '"project" was not defined') unless project_raw

        project_raw
      end

      def resolve_branch
        raise(StandardError, '"branch" was not defined') unless branch_raw

        branch_raw
      end

      def resolve_change_id
        [project_raw, branch_raw, change_id_nr].compact.join('~')
      end
    end
  end
end
