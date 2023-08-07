# frozen_string_literal: true

require 'source-monitor/gerrit/rest/api'
require 'source-monitor/gerrit/api/changes'
require 'source-monitor/gerrit/identifier'
require 'source-monitor/gerrit/patchset'

RSpec.describe SourceMonitor::Gerrit::Patchset do
  subject(:patchset) { described_class.new(identifier, changes) }

  let(:changes) { SourceMonitor::Gerrit::API::Changes.new(rest_api) }
  let(:rest_api) do
    SourceMonitor::Gerrit::REST::API.new(user: TEST_GERRIT_USR, key: TEST_GERRIT_PSW, base_uri: BASE_URL)
  end

  let(:change_id_nr) { 'Iaa00000000000000000000000000000000000001' }
  let(:project_name) { 'dummy_patchset_change' }
  let(:commit_sha1)  do
    Dir.chdir(File.join(File.dirname(__FILE__), 'test-gerrit', project_name)) do
      `git rev-parse HEAD`
    end.strip
  end

  let(:identifier) do
    SourceMonitor::Gerrit::Identifier.new(change_id_nr, revision_id: commit_sha1, project: project_name, branch: 'master')
  end

  describe '#file_names' do
    subject(:file_names) { patchset.file_names }

    it 'returns all the modified file names' do
      expect(file_names).to eq(%w[/COMMIT_MSG file_1.txt file_2.txt])
    end
  end

  describe '#files' do
    subject(:files) { patchset.files }

    let(:expected_output) do
      {
        '/COMMIT_MSG' => "6\x8BE\xA2\xE9\xDD",
        'file_1.txt' => "one\ntwo\nthree\nfour\n\n",
        'file_2.txt' => "what\nis\ngoing\non\n\n"
      }
    end

    it "returns all the files' contents" do
      expect(files.inspect).to eq(expected_output.inspect)
    end
  end
end
