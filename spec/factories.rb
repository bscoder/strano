FactoryGirl.define do

  factory :user do
    username Faker::Internet.user_name
    email Faker::Internet.email
  end

  factory :project do
    url 'git@github.com:joelmoss/strano.git'
  end

end
