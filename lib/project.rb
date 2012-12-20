require 'bundler'
Bundler.require

module Project
  def self.root
    @root ||= Pathname(File.expand_path("../..", __FILE__))
  end

  def self.env
    @env ||= (ENV["RACK_ENV"] || "development")
  end

  def self.config
    config_file = Pathname.new File.join(root, "config", "application.yml")

    if config_file.file?
      YAML.load(ERB.new(config_file.read).result)[env]
    else
      ENV
    end
  end

  def self.redis
    @redis ||= (
      url = URI(ENV['REDISTOGO_URL'] || "redis://127.0.0.1:6379")

      base_settings = {
        host: url.host,
        port: url.port,
        db: url.path[1..-1],
        password: url.password
      }

      Redis::Namespace.new("links:#{env}", redis: Redis.new(base_settings))
    )
  end
end

require_relative 'project/app'
require_relative 'project/list'
