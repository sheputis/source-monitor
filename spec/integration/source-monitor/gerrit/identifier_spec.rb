# frozen_string_literal: true

require 'source-monitor/gerrit/identifier'

RSpec.describe SourceMonitor::Gerrit::Identifier do
  subject(:identifier) { described_class.new }

  describe '#change_id_nr' do
    subject(:method_call) { identifier.change_id_nr }

    context 'when the revision revision_id was never specified' do
      it 'raises an error' do
        expect { method_call }.to raise_error(StandardError)
      end
    end

    context 'when the revision revision_id is specified' do
      let(:identifier) { described_class.new(change_id_nr: '1234') }

      it 'raises an error' do
        expect(method_call).to eq('1234')
      end
    end
  end

  describe '#project' do
    subject(:method_call) { identifier.project }

    context 'when the revision project was never specified' do
      it 'raises an error' do
        expect { method_call }.to raise_error(StandardError)
      end
    end

    context 'when the project is specified' do
      let(:identifier) { described_class.new(project: '1234') }

      it 'raises an error' do
        expect(method_call).to eq('1234')
      end
    end
  end

  describe '#branch' do
    subject(:method_call) { identifier.branch }

    context 'when the branch was never specified' do
      it 'raises an error' do
        expect { method_call }.to raise_error(StandardError)
      end
    end

    context 'when the branch is specified' do
      let(:identifier) { described_class.new(branch: '1234') }

      it 'raises an error' do
        expect(method_call).to eq('1234')
      end
    end
  end

  describe '#revision_id' do
    subject(:method_call) { identifier.revision_id }

    context 'when the revision revision_id was never specified' do
      it 'raises an error' do
        expect { method_call }.not_to raise_error(StandardError)
      end
    end

    context 'when the revision revision_id is specified' do
      let(:identifier) { described_class.new(revision_id: '1234') }

      it 'raises an error' do
        expect(method_call).to eq('1234')
      end
    end
  end

  describe '#change_id' do
    subject(:method_call) { identifier.change_id }

    context 'when no argument is specified' do
      it 'raises an error' do
        expect { method_call }.to raise_error(StandardError, '"change_id_nr" was not defined')
      end
    end

    context 'when the change_id_nr is specified' do
      let(:identifier) { described_class.new(change_id_nr: '1234') }

      it 'returns expected value' do
        expect(method_call).to eq('1234')
      end
    end

    context 'when the change_id_nr and branch are specified' do
      let(:identifier) { described_class.new(change_id_nr: '1234', branch: 'master') }

      it 'returns expected value' do
        expect(method_call).to eq('master~1234')
      end
    end

    context 'when change_id_nr, branch and project are specified' do
      let(:identifier) { described_class.new(change_id_nr: '1234', branch: 'master', project: 'source_monitor') }

      it 'returns expected value' do
        expect(method_call).to eq('source_monitor~master~1234')
      end
    end

    context 'when the arguments contain url unfriendly characters' do
      let(:identifier) { described_class.new(change_id_nr: '123  4', branch: 'ma  -??ster', project: 'source/mon/-itor') }

      it 'returns expected value' do
        expect(method_call).to eq('source%2Fmon%2F-itor~ma%20%20-%3F%3Fster~123%20%204')
      end
    end
  end
end
