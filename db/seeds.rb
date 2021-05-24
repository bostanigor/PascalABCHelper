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


tasks.map do |task|
  students.map do |student|
    Solution.create!(
      student: student,
      task: task,
      is_successfull: [true, false].sample,
      attempts_count: (1..10).to_a.sample
    )
  end
end

