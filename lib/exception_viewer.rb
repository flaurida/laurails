require 'erb'

class ExceptionViewer
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue Exception => e
      render_exception(e)
      puts e
    end
  end

  private

  def render_exception(e)
    # ['500', {'Content-type' => 'text/html'}, [e.message]]
    res = Rack::Response.new
    res.status = 500
    res['Content_Type'] = 'text/html'
    our_path = File.dirname(__FILE__)
    file_path = File.join(our_path, "templates", "rescue.html.erb")
    file = File.read(file_path)
    template = ERB.new(file)
    result = template.result(binding)
    res.write(result.html_safe)
    res.finish
  end
end
