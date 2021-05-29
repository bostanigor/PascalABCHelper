User.create!(email: 'admin@example.com', password: 'password', is_admin: true)

prng = Random.new

groups = (1..5).map do |i|
  Group.create!(name: "Группа-#{i}")
end

tasks = (1..5).map do |i|
  Task.create!(
    name: "Задача-#{i}",
    ref: "task-#{i}"
  )
end

students = (0..24).map do |i|
  Student.create!(
    first_name: "Имя-#{i}",
    last_name: "Фамилия-#{i}",
    group: groups.sample,

    user_attributes: {
      email: "student_#{i}@example.com",
      password: "password_#{i}",
      is_admin: false
    }
  )
end


solutions = tasks.map do |task|
  students.map do |student|
    sol = Solution.create(
      student: student,
      task: task,
    )
  end
end.flatten

(1..5).each do |attempt|
  puts "Attempt # #{attempt}"
  solutions.each do |solution|
    next if solution.is_successfull
    Attempt.create!(
      solution: solution,
      status: prng.rand(0..100) > 80 ?
        :successfull : :not_successfull,
      code_text: "CODE_TEXT_#{attempt}"
    )
  end
  sleep(5)
end


