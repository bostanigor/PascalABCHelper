User.create!(email: 'admin@example.com', password: 'password', is_admin: true)

prng = Random.new

(1..5).each do |i|
  Group.create!(name: "Группа-#{i}")
end

(0..24).each do |i|
  Student.create!(
    first_name: "Имя-#{i}",
    last_name: "Фамилия-#{i}",
    group: Group.find(Group.pluck(:id).sample),
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