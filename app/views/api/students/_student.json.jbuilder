json.(student,
  :id,
  :first_name,
  :last_name,
)

json.username student.user.username
json.completed_tasks_count student.completed_tasks_count
json.group do
  json.partial! 'api/groups/group', group: student.group
end