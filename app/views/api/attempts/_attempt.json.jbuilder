json.(attempt, :id, :status, :code_text, :created_at)
json.solution do
  json.partial! 'api/solutions/solution', solution: attempt.solution
end