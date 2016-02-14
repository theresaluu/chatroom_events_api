require 'rails_helper'

RSpec.describe 'posting an event', :type => :request do

  it 'creates an event with a post to /events' do
    post '/events', :event =>{:date => "1985­10­26T09:02:00Z", :user => "Doc", :type => "leave"}

    expect(response.content_type).to eq("application/json")

    expect(response.status_message).to eq("OK")
  end
end

describe 'POST /events' do
  it 'saves event date, action, and user' do
    date = Time.now
    params = {event: {:date => date, :user => 'Dennis', :action => 'enter'}}
    post '/events', params.to_json, set_headers

    event = Event.last
    expect(response_json['id']).to eq(event.id)
    expect(response_json['user']).to eq('Dennis')
    expect(response_json['action']).to eq('enter')
    expect(response.content_type).to eq('application/json')
    expect(response.status).to eq(200)
  end
end
