class Validator
  attr_reader :attr, :options

  def initialize(attr, options)
    @attr = attr
    @options = options
  end

  def validate(params, relation = nil)
    errors = []

    options.each do |option, value|
      if option == :uniqueness
        error = self.send(option, params, relation)
      else
        error = self.send(option, params)
      end

      errors << error if error
    end

    errors
  end

  def presence(params)
    params[attr] && params[attr] != "" ? nil : "can't be blank"
  end

  def uniqueness(params, relation)
    relation.empty? ? nil : "must be unique"
  end

  def length(params)
    min = options[:length][:minimum]
    max = options[:length][:maximum]

    if min && max
      params[attr] && params[attr].length.between?(min, max) ?
        nil : "must be between #{min} and #{max} characters long"
    elsif min
      params[attr] && params[attr].length >= min ?
        nil : "must be at least #{min} characters long"
    elsif max
      params[attr] && params[attr].length <= max ?
        nil : "must be at most #{max} characters long"
    end
  end
end
