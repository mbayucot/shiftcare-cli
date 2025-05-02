# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/models/client'

# rubocop:disable Metrics/BlockLength
RSpec.describe Models::Client do
  let(:clients) do
    [
      described_class.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
      described_class.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
      described_class.new(id: 3, full_name: 'Johnny Doe', email: 'john@example.com')
    ]
  end

  describe '.where_name_like' do
    before { allow(described_class).to receive(:all).and_return(clients) }

    it 'finds clients by partial name match' do
      result = described_class.where_name_like('john')
      expect(result.map(&:full_name)).to include('John Doe', 'Johnny Doe')
    end

    context 'when there are no matches' do
      it 'returns an empty array' do
        result = described_class.where_name_like('Nonexistent')
        expect(result).to be_empty
      end
    end
  end

  describe '.duplicates_by_email' do
    context 'with duplicate emails' do
      before { allow(described_class).to receive(:all).and_return(clients) }

      it 'returns grouped duplicates by email' do
        result = described_class.duplicates_by_email
        expect(result.keys).to include('john@example.com')
        expect(result['john@example.com'].size).to eq(2)
      end
    end

    context 'when there are no duplicates' do
      let(:clients) do
        [
          described_class.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          described_class.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com')
        ]
      end

      before { allow(described_class).to receive(:all).and_return(clients) }

      it 'returns an empty hash' do
        result = described_class.duplicates_by_email
        expect(result).to eq({})
      end
    end
  end

  describe '.find_by_email' do
    before { allow(described_class).to receive(:all).and_return(clients) }

    it 'returns the client when email matches' do
      client = described_class.find_by_email('john@example.com')
      expect(client.full_name).to eq('John Doe')
    end

    it 'returns nil when email does not match' do
      client = described_class.find_by_email('nope@example.com')
      expect(client).to be_nil
    end
  end

  describe '.all' do
    it 'returns [] and warns if loading fails' do
      described_class.reset_cache!
      described_class.instance_variable_set(:@clients, nil)

      allow(Services::LoadClients).to receive(:new).and_return(
        double(call: Dry::Monads::Failure('boom'))
      )

      expect do
        described_class.all
      end.to output(/Failed to load clients: boom/).to_stderr

      expect(described_class.instance_variable_get(:@clients)).to eq([])
    end
  end

  describe '.reset_cache!' do
    it 'clears the cached clients' do
      described_class.reset_cache!
      expect(described_class.instance_variable_get(:@clients)).to be_nil
    end
  end
end
# rubocop:enable Metrics/BlockLength
