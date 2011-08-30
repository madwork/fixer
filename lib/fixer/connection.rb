module Fixer
  module Connection
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
