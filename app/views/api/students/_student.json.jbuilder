json.(student,
  :id,
  :first_name,
  :last_name,
)

json.birthdate student.birthdate&.strftime("%F")

json.email student.user.email
json.group do
  json.partial! 'api/groups/group', group: student.group
end