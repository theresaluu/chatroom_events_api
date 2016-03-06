require 'pry'
require 'rails_helper'

describe 'GET /events?from=DATE&to=DATE' do
  it 'returns events with given date' do
    events = []
    events << FactoryGirl.create(:event, date: Time.parse("2015-05-26T09:00Z"))
    events << FactoryGirl.create(:event, date: Time.parse("2015-09-26T09:00Z"))
    events << FactoryGirl.create(:event, date: Time.parse("2015-05-14T09:00Z"))

    get "/events", {'from' => Time.parse("2015-05-13T00:00Z"),'to' => Time.parse("2015-06-13T23:59Z")}

    binding.pry
    #first event should be included
    expect(response_json['events'][0]['date']).to eq(events[0].date.iso8601)
    expect(response_json['events'][0]['user']).to eq(events[0].user)
    expect(response_json['events'][0]['action']).to eq(events[0].action)

    #third event should be included
    expect(response_json['events'][1]['date']).to eq(events[2].date.iso8601)
    expect(response_json['events'][1]['user']).to eq(events[2].user)
    expect(response_json['events'][1]['action']).to eq(events[2].action)
  end
end

describe 'POST /events' do
  it 'saves event date, action, and user' do
    date = Time.now
    params = {event: {:date => date, :user => 'Dennis', :action => 'enters'}}
    post '/events', params.to_json, set_headers

    event = Event.last
    expect(response_json['id']).to eq(event.id)
    expect(response_json['user']).to eq('Dennis')
    expect(response_json['action']).to eq('enters')
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
