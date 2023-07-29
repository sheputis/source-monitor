# frozen_string_literal: true

require 'rest-client'

module SourceMonitor
  module Jenkins
    # Provides the console output of a Jenkins job.
    class Console
      attr_reader :username, :password, :server_url

      def initialize(username, password, server_url)
        @username   = username
        @password   = password
        @server_url = server_url
      end

      # @param [String] job_name Full path of the job
      # @param [Integer] build_number
      # @return [String]
      def get(job_name, build_number)
        begin
          # Make a GET request to the console output URL with credentials
          response = create_request(console_url(job_name, build_number))
          if response.code == 200
            console_output = response.body

            puts "uploaded console log from #{job_name}##{build_number} succesfully"
          else
            puts "Error retrieving console output. HTTP status code: #{response.code}"
          end
        rescue RestClient::ExceptionWithResponse => e
          puts "Error retrieving console output: #{e.response}"
        end
        console_output
      end

      private

      def console_url(job_name, build_number)
        "#{server_url}/job/#{job_name}/#{build_number}/consoleText"
      end

      def create_request(console_url)
        RestClient::Request.execute(
          method: :get,
          url: console_url,
          user: username,
          password: password
        )
      end
    end
  end
end
