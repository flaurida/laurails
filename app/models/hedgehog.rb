class Hedgehog < LaurailsrecordBase
  attr_accessor :id, :name, :color, :owner_id

  belongs_to :owner, class_name: "Person", foreign_key: :owner_id
  has_one_through :house, :house, :owner
end
