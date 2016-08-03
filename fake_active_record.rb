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
      DB.execute("SELECT * FROM posts")
    end

    def find(id, *args)
      # raise ArgumentError.new("No id found") if !self.columns.include?(id)
      DB.execute("SELECT * FROM posts WHERE id = #{id}")
    end

    def first
      DB.execute("SELECT * FROM posts LIMIT 1")
    end

    def last
      DB.execute("SELECT * FROM posts ORDER BY id DESC LIMIT 1")
    end

    def select(*args)
      raise ArgumentError.new("#{self} does not have those columns") if (self.columns.keys & args).empty?
      DB.execute("SELECT #{args.join(', ')} FROM posts")
    end

    def count
      DB.execute("SELECT COUNT(*) num FROM posts")
    end

    def where(hash)
      raise ArgumentError.new("#{self} does not have those columns") if (self.columns.keys & hash.keys).empty?
      str = "SELECT * FROM posts WHERE "
      hash.each do |key, value|
        str += "#{key} = #{value} AND "
      end
      DB.execute(str[0..-5])
    end

    def create(hash)
      puts "inputing values"
      DB.execute("
        INSERT INTO #{self.table_name}
        (#{hash.keys.join(', ')})
        VALUES (#{hash.values.join(', ')});")
    end
  end

# hash.values.map(&:to_s)


  end
end
