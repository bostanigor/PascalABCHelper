class Student < ApplicationRecord
  include Sortable
  include Filterable

  belongs_to :user, dependent: :destroy
  belongs_to :group

  has_many :solutions

  scope :filter_by_group_id, -> (group_id) { where group_id: group_id }
  scope :filter_by_first_name, -> (first_name) { where("first_name ILIKE ?", "%#{first_name}%") }
  scope :filter_by_last_name, -> (last_name) { where("last_name ILIKE ?", "%#{last_name}%") }

  accepts_nested_attributes_for :user
end
