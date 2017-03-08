class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req_method = req.params['_method'] || req.request_method
    @http_method == req_method.downcase.to_sym && @pattern.match(req.path)
  end

  def run(req, res)
    params = @pattern.match(req.path)
    route_params = {}
    params.names.each { |name| route_params[name] = params[name] }

    @controller_class.new(req, res, route_params).invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    route = match(req)

    if route
      route.run(req, res)
    else
      res.status = 404
      res.write("That path was not found :(")
    end
  end
end
