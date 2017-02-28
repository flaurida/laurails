require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @primary_key = options[:primary_key] ? options[:primary_key] : :id
    @foreign_key = options[:foreign_key] ? options[:foreign_key] : "#{name}_id".to_sym
    @class_name = options[:class_name] ? options[:class_name] : "#{name}".camelcase
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @primary_key = options[:primary_key] ? options[:primary_key] : :id
    @foreign_key = options[:foreign_key] ? options[:foreign_key] : "#{self_class_name.underscore}_id".to_sym
    @class_name = options[:class_name] ? options[:class_name] : name.to_s.camelcase.singularize
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_value = self.send(options.foreign_key)
      options.model_class.where({options.primary_key => foreign_key_value}).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    assoc_options[name] = options #need to save this too right?
    p name
    define_method(name) do
      foreign_key_value = self.send(options.primary_key)
      options.model_class.where({options.foreign_key => foreign_key_value})
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.model_class.table_name
      through_table = through_options.model_class.table_name

      has_one = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
        ON
          #{source_table}.#{source_options.primary_key} =
          #{through_table}.#{source_options.foreign_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL

      source_options.model_class.new(has_one.first)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class LaurailsrecordBase
  extend Associatable
end
