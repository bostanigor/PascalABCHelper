class Task < ApplicationRecord
  include Sortable
  include Filterable

  validates :name, uniqueness: true

  has_many :solutions, dependent: :destroy

  scope :filter_by_name, -> (name) { where("name ILIKE ?", "%#{name}%") }
  scope :filter_by_description, -> (description) { where("description ILIKE ?", "%#{description}%") }
end
