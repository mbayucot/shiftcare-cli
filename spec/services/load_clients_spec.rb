# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/services/load_clients'
require_relative '../../app/models/client'

# rubocop:disable Metrics/BlockLength
RSpec.describe Services::LoadClients do
  describe '#call' do
    let(:loader) { described_class.new }

    context 'when the file exists and contains valid JSON' do
      it 'loads the clients successfully' do
        path = File.expand_path('../../clients.json', __dir__)
        result = loader.call(path)

        expect(result).to be_success
        expect(result.value!).to be_an(Array)
        expect(result.value!.first).to be_a(Models::Client)
      end
    end

    context 'when the file does not exist' do
      it 'returns a failure result' do
        path = 'non_existent_file.json'
        result = loader.call(path)

        expect(result).to be_failure
        expect(result.failure).to eq("File not found: #{path}")
      end
    end

    context 'when the file contains invalid JSON' do
      it 'returns a failure result' do
        path = File.expand_path('../../spec/fixtures/bad.json', __dir__)
        result = loader.call(path)

        expect(result).to be_failure
        expect(result.failure).to match(/expected object key|parsing/i)
      end
    end

    context 'when the file contains data missing required fields' do
      it 'skips invalid entries' do
        path = File.expand_path('../../spec/fixtures/partial.json', __dir__)
        result = loader.call(path)

        expect(result).to be_success
        valid_clients = result.value!
        expect(valid_clients).to all(be_a(Models::Client))
      end
    end

    context 'when the file contains empty JSON' do
      it 'returns an empty list' do
        path = File.expand_path('../../spec/fixtures/empty.json', __dir__)
        result = loader.call(path)

        expect(result).to be_success
        expect(result.value!).to eq([])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
