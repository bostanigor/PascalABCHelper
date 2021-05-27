json.data do
  json.email user.email
  json.first_name student&.first_name
  json.last_name student&.last_name
end