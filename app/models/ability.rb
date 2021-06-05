# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Task

      if user.is_admin?
        can :manage, :all
        cannot :create, Attempt
      else
        @student = user.student
        can :read, Student, id: @student.id
        can :change_password, Student, id: @student.id
        can :read, Solution, student_id: @student.id
        can :read, Attempt, solution: { student_id: @student.id }
        can :create, Attempt
      end
    end
  end
end
