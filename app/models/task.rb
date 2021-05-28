class Task < ApplicationRecord
  has_many :solutions, dependent: :destroy
end
