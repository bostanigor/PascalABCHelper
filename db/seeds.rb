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
    birthdate: Date.new(
      prng.rand(2000..2005),
      prng.rand(1..12),
      prng.rand(1..28)
    ),

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
      is_successfull: prng.rand(0..100) > 80
    )
  end
end.flatten

(1..5).each do |attempt|
  puts "Attempt # #{attempt}"
  solutions.each do |solution|
    next if solution.is_successfull
    solution.update(is_successfull: prng.rand(0..100) > 80)
  end
  sleep(5)
end


