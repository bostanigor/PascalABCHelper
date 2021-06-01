class Task < ApplicationRecord
  include Sortable
  include Filterable

  has_many :solutions, dependent: :destroy

  scope :filter_by_name, -> (name) { where("name ILIKE ?", "%#{name}%") }
end
