json.data do
  json.email user.email
  json.first_name student&.first_name
  json.last_name student&.last_name
  json.group do
    student.present? ?
      (json.partial! 'api/groups/group', group: student&.group)
      : nil
  end
  json.is_admin user.is_admin
end