require 'sqlite3'
require 'yaml'

CONFIG = YAML.load_file("./config/database.yml")

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
DATABASE_SQL_FILE = File.join(ROOT_FOLDER, 'database.sql')
DATABASE_DB_FILE = File.join(ROOT_FOLDER, 'database.db')

class DBConnection
  def self.open
    @db = SQLite3::Database.new(full_db_file_path)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{full_db_file_path}'",
      "cat '#{full_sql_file_path}' | sqlite3 '#{full_db_file_path}'"
    ]

    commands.each { |command| `#{command}` }
    open
  end

  def self.full_db_file_path
    File.join(ROOT_FOLDER, "#{CONFIG["db_file_name"]}.db")
  end

  def self.full_sql_file_path
    File.join(ROOT_FOLDER, "#{CONFIG["db_file_name"]}.sql")
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
