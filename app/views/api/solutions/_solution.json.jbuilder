json.(solution, :id, :is_successfull, :attempts_count, :last_attempt_at)

json.student do
  json.partial! 'api/students/student', student: solution.student
end

json.task do
  json.partial! 'api/tasks/task', task: solution.task
end