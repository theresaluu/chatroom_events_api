class Event < ActiveRecord::Base
  validates :user, presence: true
  validates :action, presence: true
  validates :date, presence: true
end
