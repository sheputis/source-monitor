# frozen_string_literal: true

require 'base64'

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
        # @param [Identifier#change_id] change_id
        # @param [Identifier#revision_id] revision_id
        # @return [Hash]
        def list_files(change_id, revision_id)
          rest_api.get("#{ENDPOINT}/#{change_id}/revisions/#{revision_id}/files/")
        end

        # https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#get-content
        # @param [Identifier#change_id] change_id
        # @param [Identifier#revision_id] revision_id
        # @param [String] file_id The path of the file https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html#file-id
        # @return [String]
        def get_content(change_id, revision_id, file_id)
          Base64.decode64(
            rest_api.get("#{ENDPOINT}/#{change_id}/revisions/#{revision_id}/files/#{file_id}/content", raw: true)
          )
        end
      end
    end
  end
end
