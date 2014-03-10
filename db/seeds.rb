25.times do
  @password = Faker::Internet.password
  Account.create!(
      handle: Faker::Internet.user_name,
      description: Faker::Lorem.paragraph,
      user: User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: @password,
          password_confirmation: @password
      ),
      technician: [true, false].sample
  )
end

@admins = Account.where(technician: true)

10.times do
  Group.create!(
      name: Faker::Company.name,
      description: Faker::Company.bs,
      code: Faker::Internet.domain_word,
      admin: @admins.sample
  )
end

@accounts = Account.all

@accounts.each do |a|
  @groups = Group.all

  Array(2..6).sample.times do
    group = @groups.shuffle.shift
    a.member_groups << group unless a.member_groups.include? group
  end
end

10.times do
  Category.create!(
      name: "#{Faker::Lorem.word}.#{Random.rand(0..999)}",
      description: Faker::Lorem.sentence
  )
end



25.times do
  @categories = Category.all.shuffle

  Issue.create!(
      subject: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      categories: Array(1..3).sample.times.map {  @categories.shift },
      account: @accounts.sample
  )
end

@issues = Issue.all

@issues.each do |i|
  Array(1..3).sample.times do
    i.comments.create!(
        comment: Faker::Lorem.sentence,
        account: @accounts.shuffle.first
    )
  end

  Array(3..6).sample.times do
    i.solutions.create!(
        solution: Faker::Lorem.paragraph,
        account: @accounts.shuffle.first
    )
  end
end

