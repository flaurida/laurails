require_relative 'db_connection'
require_relative '01_sql_object'
require_relative 'bonus_relation'

module Searchable
  # Eager implementation
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")

    found = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    found.map { |attrs_hash| self.new(attrs_hash) }
  end

  # Lazy, stackable implementation
  # def where(params)
  #   raise 'Must give params!' if params.empty?
  #   raise 'Invalid column!' unless params.keys.all? { |key| self.columns.include?(key) }
  #   Relation.new(params, self)
  # end
end

class SQLObject
  extend Searchable
end
