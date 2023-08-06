# frozen_string_literal: true

require 'source-monitor/gerrit/rest/api'

RSpec.describe SourceMonitor::Gerrit::REST::API do
  subject(:connection) { described_class.new(user: user, key: pass, base_uri: base_url) }

  let(:user)     { TEST_GERRIT_USR }
  let(:pass)     { TEST_GERRIT_PSW }
  let(:base_url) { 'http://localhost:8080' }
  let(:url_slug) { '/a/changes' }

  describe '#get' do
    context 'when requesting any changes' do
      let(:url_slug) { '/a/changes' }

      it 'returns some results' do
        expect(connection.get(url_slug)).not_to be_empty
      end
    end

    context 'when the request is some nonsense' do
      let(:url_slug) { '/whabadabadooo' }

      it 'raises an error' do
        expect { connection.get(url_slug) }.to raise_error(RuntimeError, 'Non-JSON response: Not Found')
      end
    end

    context 'when the credentials are incorrect' do
      let(:pass) { 'wrong_secret' }

      it 'raises an error' do
        expect { connection.get(url_slug) }.to raise_error(RuntimeError, 'Non-JSON response: Unauthorized')
      end
    end
  end
end
