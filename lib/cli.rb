# frozen_string_literal: true

require_relative '../app/controllers/client_controller'
require_relative '../app/models/client'

module CLI
  class Runner
    def self.run(args)
      return help if args.empty?

      case args.first
      when 'search' then handle_search(args[1..])
      when 'duplicates' then handle_duplicates
      else help
      end
    end

    def self.handle_search(args)
      field = args.length == 2 ? args[0] : 'name'
      query = args.length == 2 ? args[1] : args[0]
      ClientController.search(field, query)
    end

    def self.handle_duplicates
      ClientController.duplicates
    end

    def self.help
      puts 'Usage: shiftcare [search <field> <query> | duplicates]'
    end
  end
end
