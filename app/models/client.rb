# frozen_string_literal: true

require 'json'
require_relative '../services/load_clients'

module Models
  class Client
    attr_reader :id, :full_name, :email

    DATA_PATH = File.expand_path('../../clients.json', __dir__)
    @clients = nil

    def initialize(id:, full_name:, email:)
      @id = id
      @full_name = full_name
      @email = email
    end

    class << self
      def all
        return @clients if @clients

        loader = Services::LoadClients.new
        result = loader.call(DATA_PATH)

        @clients = if result.success?
                     result.value!
                   else
                     warn "⚠️  Failed to load clients: #{result.failure}"
                     []
                   end
      end

      def where_name_like(query)
        query = query.downcase
        all.select { |c| c.full_name.downcase.include?(query) }
      end

      def find_by_email(email)
        all.find { |c| c.email == email }
      end

      def duplicates_by_email
        all.group_by(&:email).select { |_, list| list.size > 1 }
      end

      def reset_cache!
        @clients = nil
      end
    end
  end
end
