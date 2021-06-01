json.data do
  json.(settings, :retry_interval, :code_text_limit)
  json.attempts_count Attempt.all.count
end