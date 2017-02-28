require_relative 'db_connection'
require 'active_support/inflector'

class LaurailsrecordBase
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
        *
      FROM
        #{table_name}
    SQL
  end

  def self.finalize!
    columns.each do |name|
      define_method(name) { attributes[name] }

      define_method("#{name}=".to_sym) do |value|
        attributes[name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(all)
  end

  def self.parse_all(results)
    parsed = []
    results.each { |attrs_hash| parsed << self.new(attrs_hash) }
    parsed
  end

  def self.find(id)
    found = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    found.empty? ? nil : self.new(found.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      self.send("#{attr_name}=".to_sym, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col_name| self.send(col_name) }
  end

  def insert
    col_names = self.class.columns
    question_marks = (["?"] * col_names.count).join(", ")
    col_names = col_names.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns.map { |col_name| "#{col_name} = ?"}.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id ? update : insert
  end
end
