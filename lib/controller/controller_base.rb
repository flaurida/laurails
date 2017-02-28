require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative 'session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = @req.params.merge(route_params)
    @@csrf_protection ||= false
  end

  def self.protect_from_forgery
    @@csrf_protection = true
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    !!@already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Cannot double render!" if already_built_response?

    @res.header['location'] = url
    @res.status = 302
    @already_built_response ||= @res
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Cannot double render!" if already_built_response?

    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response ||= @res
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template_path = "app/views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    contents = File.read(template_path)
    template = ERB.new(contents)
    result = template.result(binding)
    render_content(result, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if @@csrf_protection && req.request_method != "GET"
        check_authenticity_token
    end

    send(name)

    unless already_built_response?
      render(name)
    end
  end

  def form_authenticity_token
    @token ||= SecureRandom::urlsafe_base64(16)
    session['authenticity_token'] = @token
    session.store_session(res)
    @token
  end

  def check_authenticity_token
    unless session['authenticity_token'] &&
      session['authenticity_token'] == params['authenticity_token']
      raise "Invalid authenticity token"
    end
  end
end
