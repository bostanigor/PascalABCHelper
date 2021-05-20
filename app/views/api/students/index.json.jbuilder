json.data do
  json.array! students, partial: 'api/students/student', as: :student
end

json.meta meta