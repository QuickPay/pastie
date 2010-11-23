class Scruffy < Padrino::Application
  register CodehighlighterInitializer
  register Padrino::Mailer
  register Padrino::Helpers

  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  # enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  configure :development do
    require 'rack/debug'
    use Rack::Debug
  end

  # error 404 do
  #   render 'errors/404'
  # end

  get '/?' do
    render 'index'
  end

  get '/p/:id' do
    id = params[:id]
    id = Base64.decode64(id).unpack("H*") if id.length == 16
    @paste = Paste.find(id) rescue nil
    @paste = @paste.first if @paste.is_a? Array
    #debugger

    if @paste.nil? or @paste.class != Paste
      render 'nopaste'
    else
      render 'paste'
    end
  end
  
  post :new do
    paste = Paste.new
    paste.title = params[:title]
    paste.type = params[:type] || 'text'
    paste.paste = request.body.readlines.join("")
    paste.save
    #debugger
    return Base64.encode64([paste.id.to_s].pack("H*")).chomp
  end
end
