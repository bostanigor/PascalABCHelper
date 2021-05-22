class Student < ApplicationRecord
  include Sortable

  belongs_to :user
  belongs_to :group

  has_many :solutions

  accepts_nested_attributes_for :user
end
