require "rails_helper"

RSpec.describe Event, 'Post' do
  it { should validate_presence_of(:user)}
  it { should validate_presence_of(:action)}
  it { should validate_presence_of(:date)}

  describe 'comments validation' do
    context 'if action is "comments"' do
      subject { FactoryGirl.build(:event, action: 'comments') }

      it { should validate_presence_of(:message) }
    end

    context 'if action is not "comments"' do
      subject { FactoryGirl.build(:event, action: 'enters') }

      it { should_not validate_presence_of(:message) }
    end
  end

  describe 'highfives validation' do
    context 'if action is "highfives"' do
      subject { FactoryGirl.build(:event, action: 'highfives') }

      it{ should validate_presence_of(:otheruser) }
    end
    context 'if action is not "highfives"' do
      subject { FactoryGirl.build(:event, action: 'leaves') }

      it { should_not validate_presence_of(:otheruser) }
    end
  end
end
