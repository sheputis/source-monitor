# frozen_string_literal: true

module SourceMonitor
  module Gerrit
    module API
      # The Changes endpoint of the Gerrit API
      # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#change-endpoints
      class Changes
        ENDPOINT = '/a/changes'
        attr_reader :rest_api

        def initialize(rest_api)
          @rest_api = rest_api
        end

        # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#list-files
        def list_files(change_id, revision_id)
          rest_api.get("#{ENDPOINT}/#{change_id}/revisions/#{revision_id}/files/")
        end
      end
    end
  end
end
