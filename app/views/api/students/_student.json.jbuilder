json.(student,
  :id,
  :first_name,
  :last_name,
)

json.email student.user.email
json.group do
  json.partial! 'api/groups/group', group: student.group
end