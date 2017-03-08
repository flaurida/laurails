class AssetServer
  def initialize(app)
    @app = app
  end

  def call(env)
    file_path = Regexp.new("(\/app/assets/images\/.*)")
    req = Rack::Request.new(env)

    if file_path.match(req.path)
      res = Rack::Response.new
      static_file_path = File.join("./", req.path)

      if File.exist?(static_file_path)
        res.status = 200
        content_type = "." + req.path.split(".").last
        res['Content-type'] = Rack::Mime::MIME_TYPES[content_type]
        res.write(File.read(static_file_path))
      else
        res.status = 404
        res['Content-type'] = 'text/html'
        res.write("Cannot find file :(")
      end

      res.finish
    else
      @app.call(env)
    end
  end
end
