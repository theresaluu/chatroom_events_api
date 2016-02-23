require "rails_helper"

RSpec.describe Event, 'Post' do
  it { should validate_presence_of(:user)}
  it { should validate_presence_of(:action)}
  it { should validate_presence_of(:date)}
end
