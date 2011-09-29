# encoding: utf-8

module Models
  module ItemType
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 

       
        def parse_types_table(table)
          parse_generic_table(table) do |record, row|
            record.name,
            record.description,
            record.wearable,
            record.giftable,
            record.wear_limit,
            record.own_limit,
            record.exclusive,
            record.usable = row[1..-1]
          end
        end

        def bool(val)
          ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
        end

        require "csv"
        def parse_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_types_table data
        end

      end
    end
  end
end
