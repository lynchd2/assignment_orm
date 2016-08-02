module FakeActiveRecord
  class BASE
    # CLASS method on any
    # model object
    # that returns pluralized
    # version of class name
    def self.table_name
      "#{self.name.downcase}s"
    end


    # gives you a hash of {column_name: column_type }
    # for your table
    def self.schema
      return @schema if @schema

      @schema = {}

      # example:
      # If you're a Post
      # runs DB.table_info("posts")
      DB.table_info(table_name) do |row|
        @schema[row["name"]] = row["type"]
      end

      @schema
    end

    # convenience wrapper for your schema's column names
    def self.columns
      schema.keys
    end

  class << self
    def all
      "SELECT * FROM articles"
    end

    def find(id)
      raise ArgumentError.new("No id found") if !self.columns.include?(id)
      "SELECT * FROM articles WHERE id = #{id}"
    end

    def first
      "SELECT * FROM articles LIMIT 1"
    end

    def last
      "SELECT * FROM articles ORDER BY id DESC LIMIT 1"
    end

    def select(*args)
      raise ArgumentError.new("#{self} does not have those columns") if (self.columns.keys & args).empty?
      "SELECT #{args.join(', ')} FROM articles"
    end

    def count
      "SELECT COUNT(*) num FROM articles"
    end

    def where(hash)
      raise ArgumentError.new("#{self} does not have those columns") if (self.columns.keys & hash.keys).empty?
      str = "SELECT * FROM articles WHERE "
      hash.each do |key, value|
        str += "#{key} = #{value} AND "
      end
      str[0..-5]
    end
  end


  end
end

