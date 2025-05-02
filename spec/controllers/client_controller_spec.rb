# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/controllers/client_controller'
require_relative '../../app/models/client'

# rubocop:disable Metrics/BlockLength
RSpec.describe Controllers::ClientController do
  subject(:controller) { described_class.new }

  # ✅ Default mocks to avoid NameError
  let(:search_results) { [] }
  let(:duplicate_results) { {} }

  before do
    allow(Models::Client).to receive(:where_name_like).and_return(search_results)
    allow(Models::Client).to receive(:duplicates_by_email).and_return(duplicate_results)
  end

  describe '#search' do
    context 'when clients match the query' do
      let(:search_results) do
        [Models::Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com')]
      end

      it 'prints matching client results' do
        expect { controller.search(['john']) }.to output(/John Doe \(john@example.com\)/).to_stdout
      end
    end

    context 'when no clients match the search' do
      let(:search_results) { [] }

      it 'prints no results found message' do
        expect { controller.search(['unknown']) }.to output(/No clients found matching 'unknown'/).to_stdout
      end
    end
  end

  describe '#duplicates' do
    context 'when there are duplicate emails' do
      let(:duplicate_results) do
        {
          'john@example.com' => [
            Models::Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
            Models::Client.new(id: 2, full_name: 'Johnny Doe', email: 'john@example.com')
          ]
        }
      end

      it 'prints duplicate email groups' do
        expect { controller.duplicates }.to output(/Duplicate email: john@example.com/).to_stdout
      end
    end

    context 'when there are no duplicate emails' do
      let(:duplicate_results) { {} }

      it 'prints no duplicates found message' do
        expect { controller.duplicates }.to output(/No duplicate emails found/).to_stdout
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
