module Project
  class List
    attr_reader :id

    def initialize(id = nil)
      @id = id || generate_id
    end

    def urls
      Project.redis.hgetall(key)
    end

    def add_url(value)
      field = generate_id
      value = "http://#{value}" unless value.include?("://")
      Project.redis.hset(key, field, value)
      { id: field, url: value }
    end

    def remove_url(field)
      Project.redis.hdel(key, field)
    end

    def key
      "list:#{id}"
    end

    def to_s
      id.to_s
    end

    private

      def generate_id
        SecureRandom.hex(3)
      end
  end
end