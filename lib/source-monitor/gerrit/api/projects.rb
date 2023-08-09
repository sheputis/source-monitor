# frozen_string_literal: true

require 'base64'

module SourceMonitor
  module Gerrit
    module API
      # The Projects endpoint of the Gerrit API
      # https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html
      class Projects
        ENDPOINT = '/a/projects'

        attr_reader :rest_api

        def initialize(rest_api)
          @rest_api = rest_api
        end

        # https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-commit
        # @param [Identifier#project_name] project_name
        # @param [Identifier#revision_id] revision_id
        # @return [Hash]
        def get_commit(project_name, revision_id)
          rest_api.get("#{ENDPOINT}/#{project_name}/commits/#{revision_id}")
        end
      end
    end
  end
end
