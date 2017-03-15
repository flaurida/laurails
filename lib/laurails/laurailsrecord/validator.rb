class Validator
  attr_reader :attr, :options

  def initialize(attr, options)
    @attr = attr
    @options = options
  end

  def validate(params)
    if options[:presence]
      params[attr] && params[attr] != "" ? true : "can't be blank"
    end
  end
end
