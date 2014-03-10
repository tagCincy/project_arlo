FactoryGirl.define do

  #Users
  factory :user, class: User do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.sequence(:email) { |n| "#{Faker::Internet.email}#{n}" }
    f.password 'P@ssw0rd'
    f.password_confirmation 'P@ssw0rd'
  end

  factory :invalid_user, class: User do |f|
    f.first_name ''
    f.last_name { Faker::Name.last_name }
    f.sequence(:email) { |n| "#{Faker::Internet.email}#{n}" }
    f.password 'P@ssw0rd'
    f.password_confirmation 'P@ssw0rd'
  end

  #Accounts
  factory :account, class: Account do |f|
    f.sequence(:handle) { |n| "#{Faker::Internet.user_name}#{n}" }
    f.description { Faker::Lorem.sentence }
    f.association :user, factory: :user
  end

  factory :account_params, class: Account do |f|
    f.sequence(:handle) { |n| "#{Faker::Internet.user_name}#{n}" }
    f.description { Faker::Lorem.sentence }
    f.user_attributes { attributes_for(:user) }
  end

  factory :invalid_account_params, class: Account do |f|
    f.handle ''
    f.description { Faker::Lorem.sentence }
    f.user_attributes { attributes_for(:user) }
  end

  factory :invalid_account_user_params, class: Account do |f|
    f.handle ''
    f.description { Faker::Lorem.sentence }
    f.user_attributes { attributes_for(:invalid_user) }
  end

  factory :tech_account, class: Account do |f|
    f.sequence(:handle) { |n| "#{Faker::Internet.user_name}#{n}" }
    f.description { Faker::Lorem.sentence }
    f.technician true
    f.association :user, factory: :user
  end

  #Groups
  factory :group, class: Group do |f|
    f.sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    f.sequence(:code) { |n| "#{Faker::Internet.domain_word}#{n}" }
    f.description { Faker::Lorem.paragraph }
    f.association :admin, factory: :account
  end

  factory :group_params, class: Group do |f|
    f.sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    f.sequence(:code) { |n| "#{Faker::Internet.domain_word}#{n}" }
    f.description { Faker::Lorem.paragraph }
    f.admin_id { create(:account).id }
  end

  factory :invalid_group_params, class: Group do |f|
    f.name ''
    f.sequence(:code) { |n| "#{Faker::Internet.domain_word}#{n}" }
    f.description { Faker::Lorem.paragraph }
    f.association :admin, factory: :account
  end

  factory :member_group, class: Membership do |f|
    f.association :account, factory: :account
    f.association :group, factory: :group
  end

  #Categories

  factory :category, class: Category do |f|
    f.sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }
    f.description { Faker::Lorem.sentence }
  end

  #Issues

  factory :issue, class: Issue do |f|
    f.subject { Faker::Lorem.sentence }
    f.description { Faker::Lorem.paragraph }
    f.association :account, factory: :account
    f.categories { Array(1..3).sample.times.map { create :category } }
  end

  factory :full_issue, class: Issue do |f|
    f.subject { Faker::Lorem.sentence }
    f.description { Faker::Lorem.paragraph }
    f.association :account, factory: :account
    f.categories { Array(1..3).sample.times.map { create :category } }
    f.comments { Array(2..5).sample.times.map { create :issue_comment } }
    f.solutions { Array(2..5).sample.times.map { create :solution_with_comments } }
  end

  factory :issue_params, class: Issue do |f|
    f.subject { Faker::Lorem.sentence }
    f.description { Faker::Lorem.paragraph }
    f.account_id { create(:account).id }
    f.category_ids { Array(1..3).sample.times.map { create(:category).id } }
  end

  factory :invalid_issue_params, class: Issue do |f|
    f.subject ''
    f.description { Faker::Lorem.paragraph }
  end

  #Solutions

  factory :solution, class: Solution do |f|
    f.solution { Faker::Lorem.paragraph }
    f.association :issue, factory: :issue
    f.association :account, factory: :account
    f.accepted true
  end

  factory :solution_params, class: Solution do |f|
    f.solution { Faker::Lorem.paragraph }
    f.account_id { create(:account).id }
  end

  factory :solution_with_comments, class: Solution do |f|
    f.solution { Faker::Lorem.paragraph }
    f.association :issue, factory: :issue
    f.association :account, factory: :account
    f.comments { Array(2..5).sample.times.map { create :solution_comment } }
  end

  #Comments

  factory :comment, class: Comment do |f|
    f.sequence(:comment) { |n| "#{Faker::Lorem.sentence}#{n}" }
    f.association :account, factory: :account
  end

  factory :comment_params, class: Comment do |f|
    f.sequence(:comment) { |n| "#{Faker::Lorem.sentence}#{n}" }
    f.account_id { create(:account).id }
  end

  factory :issue_comment, class: Comment do |f|
    f.sequence(:comment) { |n| "#{Faker::Lorem.sentence}#{n}" }
    f.association :account, factory: :account
    f.association :commentable, factory: :issue
  end

  factory :solution_comment, class: Comment do |f|
    f.sequence(:comment) { |n| "#{Faker::Lorem.sentence}#{n}" }
    f.association :account, factory: :account
    f.association :commentable, factory: :solution
  end

end