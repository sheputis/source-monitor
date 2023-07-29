# frozen_string_literal: true

module SourceMonitor
  # Reads the Console output from 'Console' object and stores the
  # exact sha1s that were used in the manifest for the job where the console
  # output was taken from. Important: it can provide the difference between
  # two Manifest snapshots.
  # Usage:
  # jenkins_get = JenkinsGet.new(username, password, server_url)
  #
  # console_output_A = jenkins_get.get_console('Build-Job-Name', 250)
  # console_output_B = jenkins_get.get_console('Build-Job-Name', 251)
  #
  # snap_A = ManifestSnapshot.new(console_output_A) --> { 'repo1' => '123', 'repo2' => '456'}
  # snap_B = ManifestSnapshot.new(console_output_B) --> { 'repo1' => '123', 'repo2' => '999'}
  #
  # snap_B - snap_A                                 --> { 'repo2' => { diff: ['999', '456'] } }
  class ManifestSnapshot < Hash
    attr_reader :console_output

    def initialize(console_output)
      @console_output = console_output
      create_storage
    end

    def -(other)
      self.keys.each_with_object({}) do |key, diff|
        diff[key] = { diff: [self[key].strip, other[key].strip] } unless self[key] == other[key]
      end
    end

    private

    def create_storage
      manifest_lines = console_output.split("\n").select { |x| x.include?('Added a project') }
      manifest_lines.each do |line|
        matched = line.match(/Added a project: (?<path>.*?) at revision:(?<sha1>.*)/)
        self[matched[:path]] = matched[:sha1]
      end
    end
  end
end
