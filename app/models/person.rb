class Person < LaurailsrecordBase
  finalize!

  belongs_to :house
  has_many :hedgehogs, foreign_key: :owner_id
end
