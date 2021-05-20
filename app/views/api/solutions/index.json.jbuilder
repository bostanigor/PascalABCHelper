json.data do
  json.array! solutions, partial: 'api/solutions/solution', as: :solution
end

json.meta meta