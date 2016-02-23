require 'rails_helper'

describe 'GET /events?from=DATE&to=DATE' do
  it 'returns events with given date' do
    skip
    event_2016 = FactoryGirl.create(:event, :date => "2015­10­26T09:00:00Z")

    get "/events", {:from => Time.now.iso8601, :to => (Time.now + 1.year).iso8601}

    event = Event.last
    expect(response_json).to eq({ 'date' => event.date})
    expect(event.user).to eq({ 'user' => event.user })
    expect(event.action).to eq({'action' => event.action})
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
    expect(response_json['status']).to eq('ok')
  end

  it 'returns a non-200, application/json, {"status": "error"}' do
    params = {event: {:user => 'Tom', :action => 'salutes'}}
    post '/events', params.to_json, set_headers

    event = Event.last
    expect(response.content_type).to eq('application/json')
    expect(response.status).to eq(422)
    expect(response_json['status']).to eq("error")
  end
end

describe 'POST /events/clear' do
  it 'clears data store and returns {"status": "ok"}' do
    post '/events/clear'

    expect(response.content_type).to eq('application/json')
    expect(response.status).to eq(200)
    expect(response_json['status']).to eq("ok")
  end
end
