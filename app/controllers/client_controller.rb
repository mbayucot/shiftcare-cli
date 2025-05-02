# frozen_string_literal: true

require_relative '../models/client'

module Controllers
  class ClientController
    def search(args)
      query = args.join(' ')
      results = Models::Client.where_name_like(query)

      if results.empty?
        puts "No clients found matching '#{query}'"
      else
        results.each { |c| puts "#{c.full_name} (#{c.email})" }
      end
    end

    def duplicates
      grouped = Models::Client.duplicates_by_email

      if grouped.empty?
        puts 'No duplicate emails found.'
      else
        grouped.each do |email, group|
          puts "Duplicate email: #{email}"
          group.each { |c| puts " - #{c.full_name} (ID: #{c.id})" }
        end
      end
    end
  end
end
