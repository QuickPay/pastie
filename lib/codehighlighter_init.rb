module CodehighlighterInitializer
  def self.registered(app)
    app.use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/
  end
end