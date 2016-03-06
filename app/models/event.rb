class Event < ActiveRecord::Base
  validates :user, presence: true
  validates :action, presence: true
  validates :date, presence: true
  validates :message, presence: true,
    if: Proc.new { |e| e.action  == 'comments' }
  validates :otheruser, presence: true,
    if: Proc.new { |e| e.action == 'highfives' }
end
