require 'rails_helper'

RSpec.describe 'posting an event', :type => :request do

  it 'creates an event with a post to /events' do
    post '/events', :event =>{:date => "1985­10­26T09:02:00Z", :user => "Doc", :type => "leave"}

    expect(response.content_type).to eq("application/json")

    expect(response.status_message).to eq("OK")
  end
end
