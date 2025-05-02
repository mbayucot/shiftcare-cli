# frozen_string_literal: true

require 'json'
require 'dry/monads'
require 'dry/transaction'
require_relative '../models/client'

module Services
  class LoadClients
    include Dry::Monads[:result]
    include Dry::Transaction

    step :read_file
    step :parse_json
    step :instantiate_clients

    def read_file(path)
      return Failure("File not found: #{path}") unless File.exist?(path)

      content = File.read(path)
      Success(content)
    rescue StandardError => e
      Failure("Error reading file: #{e.message}")
    end

    def parse_json(raw)
      parsed = JSON.parse(raw)
      Success(parsed)
    rescue StandardError => e
      Failure("Error parsing JSON: #{e.message}")
    end

    def instantiate_clients(data)
      clients = data.map do |item|
        Models::Client.new(
          id: item['id'],
          full_name: item['full_name'],
          email: item['email']
        )
      end
      Success(clients)
    rescue StandardError => e
      Failure("Error building clients: #{e.message}")
    end
  end
end
