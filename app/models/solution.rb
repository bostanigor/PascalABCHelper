class Solution < ApplicationRecord
  belongs_to :student
  belongs_to :task

  before_create :set_default
  before_update :check_time
  after_save :change_task_rating

  private

  def change_task_rating
    task.all_attempts += 1
    task.successfull_attempts += 1 if is_successfull

    k = 1 - (task.successfull_attempts.to_f / task.all_attempts)
    task.rating = k * 10
    task.save
  end

  def check_time
    time_now = Time.now

    if is_successfull && is_successfull_changed? ||
       !is_successfull && !is_successfull_changed? &&
       time_now > (self.last_attempt_at + 5.seconds)
      self.attempts_count += 1
      self.last_attempt_at = time_now
    else
      raise ActiveRecord::Rollback
    end
  end

  def set_default
    self.attempts_count = 1
    self.last_attempt_at = Time.now
  end
end
