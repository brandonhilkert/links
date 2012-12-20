require "yaml"

config = YAML.load(File.read(File.expand_path('../config/application.yml', __FILE__)))
config.each do |key, value|
  ENV[key] = value.to_s unless value.kind_of? Hash
end

require './lib/project'
use Rack::Deflater

map '/assets' do
  run Project::App.sprockets
end

map '/' do
  run Project::App
end
