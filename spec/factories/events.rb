require 'factory_girl_rails'

FactoryGirl.define do
  factory :event do
    date Time.now.to_time.iso8601
    sequence(:user) {|n| "guest_#{n}"}
    action ['enter', 'leave', 'highfive', 'cheer'].sample
  end
end
