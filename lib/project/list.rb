module Project
  class List
    attr_reader :id

    def initialize(id = nil)
      @id = id || generate_id
    end

    def urls
      Project.redis.smembers(key)
    end

    def add_url(name)
      name = "http://#{name}" unless name.include?("://")
      Project.redis.sadd(key, name)
    end

    def remove_url(name)
      Project.redis.srem(key, name)
    end

    def key
      "list:#{id}"
    end

    def to_s
      id.to_s
    end
  end
end