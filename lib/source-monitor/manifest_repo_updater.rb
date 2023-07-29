# frozen_string_literal: true

require 'git'

# Example usage:
# updater           = GitManifestRepoUpdater.new()
# manifest_contents = updater.update_and_read_manifest
# puts manifest_contents
class ManifestRepoUpdater
  REPOSITORY_PATH = '<local-path-to-manifest-repo>'
  BRANCH_NAME     = '<some-branch>'
  MANIFEST_XML    = 'default.xml'

  attr_reader :repository_path, :branch_name

  def initialize(repository_path: REPOSITORY_PATH, branch_name: BRANCH_NAME)
    @repository_path = repository_path
    @branch_name = branch_name
  end

  def manifest_file_path
    File.join(repository_path, MANIFEST_XML)
  end

  def update_and_read_manifest
    repo.checkout(branch_name)
    repo.pull('origin', branch_name)
    File.read(manifest_file_path)
  end

  private

  def repo
    @repo ||= Git.open(@repository_path)
  end
end
