# frozen_string_literal: true

require 'httparty'

module SourceMonitor
  module Gerrit
    # The API class that can take Gerrit API inputs in the form of url_slugs and
    # return JSON responses.
    class API
      attr_reader :user, :key, :base_uri

      def initialize(user:, key:, base_uri:)
        @user     = user
        @key      = key
        @base_uri = base_uri
      end

      # @param [String] url_slug The gerrit API entry, for example '/a/changes/?q=status:open+is:watched&n=2'
      def get(url_slug, options = {})
        perform(:get, url_slug, options)
      end

      private

      def perform(method, url_slug, options)
        ret = HTTParty.send(method, url_slug, basic_options.merge(options)).body
        return ret if options[:raw]

        ret = ret.sub(/\A\)\]\}'\n/, '')
        return JSON.parse("[#{ret}]")[0] if ret && ret =~ /\A("|\[|\{)/

        raise("Non-JSON response: #{ret}")
      end

      def basic_options
        @basic_options ||= {
          basic_auth: {
            username: user,
            password: key
          },
          base_uri: base_uri
        }
      end
    end
  end
end
