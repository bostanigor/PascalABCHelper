class Attempt < ApplicationRecord
  belongs_to :solution

  enum status: [:successfull, :not_successfull]

  before_save :check_time

  def check_time
    time_now = Time.now
    if solution.is_successfull ||
       time_now <= (solution.last_attempt_at + 5.seconds)
      raise ActiveRecord::Rollback
    end

    solution.attempts_count += 1
    solution.last_attempt_at = time_now
    solution.is_successfull = self.successfull?
    solution.save
  end
end
