class Group < ApplicationRecord
  include Sortable
  include Filterable

  has_many :students, dependent: :destroy
  accepts_nested_attributes_for :students

  scope :filter_by_name, -> (name) { where("name ILIKE ?", "%#{name}%") }
end
