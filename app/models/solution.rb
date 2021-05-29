class Solution < ApplicationRecord
  belongs_to :student
  belongs_to :task

  has_many :attempts, dependent: :destroy
  accepts_nested_attributes_for :attempts, allow_destroy: true

  after_initialize :set_default
  after_save :change_task_rating

  def change_task_rating
    task.all_attempts += 1
    task.successfull_attempts += 1 if is_successfull

    k = 1 - (task.successfull_attempts.to_f / task.all_attempts)
    task.rating = k * 10
    task.save
  end

  private

  def set_default
    self.last_attempt_at ||= Time.now
    self.attempts_count ||= 0
  end
end
