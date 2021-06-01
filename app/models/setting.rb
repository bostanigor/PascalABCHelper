class Setting < ApplicationRecord
  validates_inclusion_of :singleton_guard, :in => [0]
  before_create :set_default

  def self.instance
    row = first
    if row.nil?
      row = Setting.create!
    end
    row
  end

  private

  def set_default
    self.retry_interval = 5
    self.singleton_guard = 0
  end
end
