require 'factory_girl_rails'

FactoryGirl.define do
  factory :event do
    date Time.new(1998, 5, 12, 6, 0, 0)
    user "Doc"
    type "enter"
  end
end
