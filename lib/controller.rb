require_relative 'controller/controller_base'
require_relative 'controller/flash'
require_relative 'controller/session'

class ControllerBase
  protect_from_forgery
end
