class Hedgehog < LaurailsrecordBase
  finalize!

  belongs_to :owner, class_name: "Person", foreign_key: :owner_id
  has_one_through :house, :house, :owner

  validates :name
  validates :color
end
