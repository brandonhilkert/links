require './lib/project'
use Rack::Deflater

map '/assets' do
  run Project::App.sprockets
end

map '/' do
  run Project::App
end
