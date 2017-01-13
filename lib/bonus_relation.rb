class Relation
  def initialize(params = {}, model_class)
    @params = params
    @model_class = model_class
  end

  def where(params)
    params.each do |key, value|
      @params[key] = value
    end

    self
  end

  def execute
    where_line  = @params.keys.map { |key| "#{key} = ?" }.join(" AND ")

    query_result = DBConnection.execute(<<-SQL, *@params.values)
      SELECT
        *
      FROM
        #{@model_class.table_name}
      WHERE
        #{where_line}
    SQL

    @model_class.parse_all(query_result)
  end

  alias_method :to_a, :execute

  def to_sql
    where_line = @params.keys.map do |key, value|
      "#{key} = #{value}"
    end.join(" AND ")

    <<-SQL
      SELECT
        *
      FROM
        #{@model_class.table_name}
      WHERE
        #{where_line}
    SQL
  end

  def method_missing(method_name, *args)
    execute.send(method_name, *args)
  end
end
