require 'factory_girl_rails'

FactoryGirl.define do
  factory :event do
    date Time.parse('2014-02-15T13:00Z')
    sequence(:user) {|n| "guest_#{n}"}
    action ['enters', 'leave', 'highfive', 'cheer'].sample

    factory :enters do
      action 'enters'
    end

    factory :leaves do
      action 'leaves'
    end

    factory :highfives do
      action 'highfives'
      otheruser 'Alicia'
    end

    factory :cheer do
      action 'conments'
      message 'She could be a farmer in those clothes!'
    end
  end
end
