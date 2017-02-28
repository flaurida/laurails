module AttrAccessorObject
  def self.attr_accessor(*names)
    names.each do |name|
      ivar_sym = "@#{name}".to_sym

      define_method(name.to_sym) do
        instance_variable_get(ivar_sym)
      end

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(ivar_sym, value)
      end
    end
  end
end
