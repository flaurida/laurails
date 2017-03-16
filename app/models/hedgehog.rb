class Hedgehog < LaurailsrecordBase
  finalize!

  belongs_to :owner, class_name: "Person", foreign_key: :owner_id
  has_one_through :house, :house, :owner

  validates :name, presence: true,
    uniqueness: true,
    length: { minimum: 3, maximum: 20 }
  validates :color
end
