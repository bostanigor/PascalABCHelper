json.(student,
  :id,
  :first_name,
  :last_name,
)

json.username student.user.username
json.group do
  json.partial! 'api/groups/group', group: student.group
end