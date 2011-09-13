module Fixer
  module Connection
    def self.create_indexes
      database.collections.select {|c| c.name !~ /system/ }.each do |c|
        c.create_index([['date', Mongo::DESCENDING]])
      end
    end

    def self.database
      @database ||= Mongo::Connection.new['fixer']
    end

    def self.database=(obj)
      unless obj.is_a? Mongo::DB
        raise(ArgumentError, "#{obj} isn't a Mongo::DB object")
      end

      @database = obj
    end
  end
end
