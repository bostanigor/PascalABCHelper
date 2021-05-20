json.data do
  json.array! groups, partial: 'api/groups/group', as: :group
end

json.meta meta