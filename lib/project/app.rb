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

    get '/:id' do
      @list = Project::List.new(params[:id])
      @urls = @list.urls
      erb :urls
    end

    post '/:id/urls' do
      list = Project::List.new(params[:id])
      unless params[:url].empty?
        list.add_url(params[:url])
      end

      redirect "/#{list}"
    end

    delete '/:id/urls' do
      list = Project::List.new(params[:id])
      list.remove_url(params[:url])
      redirect "/#{list}"
    end

  end
end