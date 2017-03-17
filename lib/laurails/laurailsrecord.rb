require_relative 'laurailsrecord/associatable'
require_relative 'laurailsrecord/db_connection'
require_relative 'laurailsrecord/laurailsrecord_base'
require_relative 'laurailsrecord/relation'
require_relative 'laurailsrecord/searchable'

class LaurailsrecordBase
  extend Associatable
  extend Searchable
end
