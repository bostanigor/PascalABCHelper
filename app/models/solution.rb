class Solution < ApplicationRecord
  include Sortable
  include Filterable

  belongs_to :student
  belongs_to :task

  has_many :attempts, dependent: :destroy
  accepts_nested_attributes_for :attempts, allow_destroy: true

  after_initialize :set_default
  after_update :change_task_rating

  scope :filter_by_task_id, -> (task_id) { where task_id: task_id }
  scope :filter_by_student_id, -> (student_id) { where student_id: student_id }

  def change_task_rating
    task.all_attempts += 1
    task.successfull_attempts += 1 if is_successfull

    k = 1 - (task.successfull_attempts.to_f / task.all_attempts)
    task.rating = k * 10
    task.save
  end

  private

  def set_default
    self.attempts_count ||= 0
  end
end
