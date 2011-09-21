module Models
  module CsvParseCommons
    def parse_generic_table(table, &proc)
      raise ArgumentError, "Missing block" unless block_given?

        new_enteries, update_enteries = table.partition{|e| e[0].blank? }
        #TODO check all id's for existence
        
        update_enteries.each do |e|
          record = self.find(e[0])
          yield(record, e) #Find by ID
          record.save
        end 

        new_enteries.each do |e|
          record = self.new 
          yield(record, e)
          record.save
        end
      end
  end
end
