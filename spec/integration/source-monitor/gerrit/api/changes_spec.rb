# frozen_string_literal: true

require 'source-monitor/gerrit/rest/api'
require 'source-monitor/gerrit/identifier'
require 'source-monitor/gerrit/api/changes'

RSpec.describe SourceMonitor::Gerrit::API::Changes do
  subject(:changes) { described_class.new(rest_api) }

  let(:rest_api) do
    SourceMonitor::Gerrit::REST::API.new(user: TEST_GERRIT_USR, key: TEST_GERRIT_PSW, base_uri: BASE_URL)
  end

  let(:change_id_nr) { 'Iaa00000000000000000000000000000000000000' }
  let(:project_name) { 'dummy_gerrit_changes_project' }
  let(:commit_sha1)  do
    Dir.chdir(File.join(File.dirname(__FILE__), 'test-gerrit', project_name)) do
      `git rev-parse HEAD`
    end.strip
  end

  let(:identifier) do
    SourceMonitor::Gerrit::Identifier.new(change_id_nr, revision_id: commit_sha1, project: project_name, branch: 'master')
  end

  describe '#list_files' do
    subject(:list_files) do
      changes.list_files(
        identifier.change_id,
        identifier.revision_id
      )
    end

    context 'when the patchset exist' do # see the test project 'dummy_gerrit_changes_project'
      let(:expected_result) do
        {
          '/COMMIT_MSG' => {
            'status' => 'A',
            'lines_inserted' => 8,
            'size_delta' => be_instance_of(Integer),
            'size' => be_instance_of(Integer)
          },
          'dummy.txt' => {
            'status' => 'A',
            'lines_inserted' => 1,
            'size_delta' => 13,
            'size' => 13
          }
        }
      end

      it 'returns the files in the specified patchset' do
        expect(list_files).to match expected_result
      end
    end
  end
end
