# frozen_string_literal: true

require 'erb'

module SourceMonitor
  module Gerrit
    # Represents values that are needed to identify a single change in Gerrit.
    # These are change_id, project, revision id or branch.
    class Identifier
      DEFAULT_REVISION_ID = 'current'

      include ERB::Util

      attr_reader :change_id_nr,
                  :project,
                  :branch,
                  :revision_id # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#revision-id

      def initialize(change_id_nr, revision_id: DEFAULT_REVISION_ID, project: nil, branch: nil)
        @change_id_nr = change_id_nr
        @revision_id = revision_id
        @project = project
        @branch = branch
      end

      # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#change-id
      def change_id
        @change_id ||= [project, branch, change_id_nr].compact.map { |param| url_encode(param) }.join('~')
      end
    end
  end
end
