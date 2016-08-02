class Article
  class << self
    def all
      "SELECT * FROM articles"
    end

    def find(id)
      "SELECT * FROM articles WHERE id = #{id}"
    end

    def first
      "SELECT * FROM articles LIMIT 1"
    end

    def last
      "SELECT * FROM articles ORDER BY id DESC LIMIT 1"
    end

    def select(*args)
      "SELECT #{args.join(', ')} FROM articles"
    end

    def count
      "SELECT COUNT(*) num FROM articles"
    end

    def where(hash)
      str = "SELECT * FROM articles WHERE "
      hash.each do |key, value|
        str += "#{key} = #{value} AND "
      end
      str[0..-5]
    end

  end

end


# Article.find(id)
# Article.first and Article.last
# Article.select(:column1, :column2) -- Note that this can take any number of parameters.
# Article.count
# Extend Article.find to also take an array of id's
# Article.where(:column1 => "value", :column2 => "value") -- Note that this takes a hash of parameters, and it essentially joins each constraint with an AND.
