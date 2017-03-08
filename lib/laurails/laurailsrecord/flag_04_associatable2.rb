require_relative '03_associatable'

# Phase IV
module Associatable


# debugger

  # def has_many_through(name, through_name, source_name)
  #   through_options = self.assoc_options[through_name]
  #
  #   define_method(name) do
  #     source_options = through_options.model_class.assoc_options[source_name]
  #     source_table = source_options.model_class.table_name
  #     through_table = through_options.model_class.table_name
  #
  #     has_many = DBConnection.execute(<<-SQL, self.send(through_options.primary_key))
  #       SELECT
  #         #{source_table}.*
  #       FROM
  #         #{source_table}
  #       JOIN
  #         #{through_table}
  #       ON
  #         #{source_table}.#{source_options.foreign_key} =
  #         #{through_table}.#{source_options.primary_key}
  #       WHERE
  #         #{through_table}.#{through_options.foreign_key} = ?
  #     SQL
  #
  #     source_options.model_class.parse_all(has_many)
  #   end
  # end
end
