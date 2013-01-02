module Project
  class App < Sinatra::Base
    set :root, Project.root
    enable  :method_override

    set :sprockets, Sprockets::Environment.new(root) { |env|
      env.append_path(root.join('assets', 'stylesheets'))
      env.append_path(root.join('assets', 'javascripts'))
    }

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      def asset_path(source)
        "/assets/" + settings.sprockets.find_asset(source).digest_path
      end
    end

    get '/' do
      erb :index
    end

    post '/lists' do
      list = Project::List.new()
      MultiJson.dump({ id: list.id })
    end

    get '/lists/:list_id' do
      content_type :json
      @list = Project::List.new(params[:list_id])
      MultiJson.dump({ list: { id: params[:list_id], urls: @list.urls.map{ |k, v| { id: k, url: v } } } })
    end

    post '/lists/:list_id/urls' do
      content_type :json
      list = Project::List.new(params[:list_id])
      body = MultiJson.load request.body.read
      item = list.add_url body.fetch("name")
      MultiJson.dump item
    end

    delete '/lists/:list_id/urls/:id' do
      list = Project::List.new(params[:list_id])
      list.remove_url(params[:id])
      :ok
    end
  end
end