class Attempt < ApplicationRecord
  include Sortable
  include Filterable

  belongs_to :solution

  before_create :check_time

  scope :filter_by_solution_id, -> (solution_id) { where solution_id: solution_id }

  def check_time
    time_now = Time.now
    interval = Setting.instance.retry_interval
    is_successfull = self.status == "success"

    if solution.is_successfull ||
        !is_successfull &&
        solution.last_attempt_at.present? &&
        time_now <= (solution.last_attempt_at + interval.seconds)
      raise ActiveRecord::Rollback
    end

    code_text_limit = Setting.instance.code_text_limit
    code_text.slice!(0, code_text_limit) if code_text.present? && code_text_limit.present?

    solution.attempts_count += 1
    solution.last_attempt_at = time_now
    solution.is_successfull = is_successfull
    solution.save
  end
end
