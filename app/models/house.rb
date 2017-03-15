class House < LaurailsrecordBase
  finalize!

  has_many :people
  has_many_through :hedgehogs, :people, :hedgehogs
end
