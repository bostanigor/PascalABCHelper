class Solution < ApplicationRecord
  belongs_to :student
  belongs_to :task

  after_create :change_task_rating

  private

  def change_task_rating
    all_solutions = task.solutions
    k = all_solutions.where(is_successfull: false).count.to_f / all_solutions.count
    task.update(rating: k * 10)
  end
end
