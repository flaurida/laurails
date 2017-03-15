require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative 'session'
require_relative 'flash'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = @req.params.merge(route_params)
    @@csrf_protection ||= false
  end

  def self.protect_from_forgery
    @@csrf_protection = true
  end

  def already_built_response?
    !!@already_built_response
  end

  def redirect_to(url)
    raise "Cannot double render!" if already_built_response?

    res.header['location'] = url
    res.status = 302
    @already_built_response ||= res
    session.store_session(res)
    flash.store_flash(res)
  end

  def render_content(content, content_type)
    raise "Cannot double render!" if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)
    @already_built_response ||= res
    session.store_session(res)
    flash.store_flash(res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore.split("_")
    controller_view = controller_name[0...-1].join("_")

    template_path = "app/views/#{controller_view}/#{template_name}.html.erb"
    contents = File.read(template_path)
    template = ERB.new(contents)
    result = template.result(binding)
    render_content(result, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

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
