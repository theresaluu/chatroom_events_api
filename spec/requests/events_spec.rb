require 'rails_helper'

describe 'GET /events?from=DATE&to=DATE' do
  let(:events) {
    dates = ["2015-05-26T09:00Z", "2015-09-26T09:00Z", "2015-05-14T09:00Z",
             "2015-06-26T19:00Z", "2015-07-26T09:30Z", "2015-10-14T08:00Z"]
    events = []
    dates.each do |date|
      events << FactoryGirl.create(:event, date: date)
    end
  }
  let(:from_date) {'2015-05-13T00:00Z'}
  let(:to_date) {'2015-06-13T23:59Z'}
  let(:first_result) {response_json['events'][0]['date']}
  let(:second_result) {response_json['events'][1]['date']}

  let(:no_results_from_date) {'2015-01-13T00:00Z'}
  let(:no_results_to_date) {'2015-04-13T23:59Z'}

  context 'given a valid start and stop date' do
    before { expect(events.count).to eq(6) }

    it 'returns events within given date range' do
      get "/events", {'from' => from_date,'to' => to_date}

      expect(response).to render_template("events/range")
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)

      expect(first_result).to be_between(from_date, to_date).inclusive
      expect(second_result).to be_between(from_date, to_date).inclusive

      #second event should not be included
      expect(response_json['events'].count).to eq(2)
      expect(first_result).to_not eq(Event.all[1].date.iso8601)
      expect(second_result).to_not eq(Event.all[1].date.iso8601)

      #results in ascending date order
      expect(second_result).to be > first_result
    end

    it 'returns no results if none within given range' do

      get "/events", {'from' => no_results_from_date,'to' => no_results_to_date}

      expect(response).to render_template("events/range")
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json.keys).to_not match(/events/)
    end
  end

  context 'given invalid "from" and "to" params' do
    #TODO: (TL) spec to show error if dates are reversed
  end
end

describe 'GET /events/summary?from=DATE&to=DATE&by=TIMEFRAME' do
  let(:events) do
    chatroom_haps = []
    chatroom_haps << FactoryGirl.create(:enters,
                                        date: "2015-05-26T09:00Z",
                                       user: "DJ Tanner")
    chatroom_haps << FactoryGirl.create(:leaves,
                                        date: "2015-05-26T10:45Z",
                                        user: "DJ Tanner")
    chatroom_haps << FactoryGirl.create(:highfives,
                                        date: "2015-05-25T09:00Z")
    chatroom_haps << FactoryGirl.create(:comments,
                                        date: "2015-05-29T01:00Z")
    chatroom_haps << FactoryGirl.create(:enters,
                                        date: "2015-05-16T09:00Z",
                                        user: "Uncle Jesse")
    chatroom_haps << FactoryGirl.create(:leaves,
                                        date: "2015-05-16T10:45Z",
                                        user: "Uncle Jesse")
    chatroom_haps
  end

  let(:from_date) {'2015-05-25T01:00Z'}
  let(:to_date) {'2015-05-27T12:00Z'}

  context 'given a valid start/stop date and timeframe' do
    before { expect(events.count).to eq(6) }

    it 'returns summary of events within given date range' do
      get "/events/summary",
        {'from' => from_date,'to' => to_date, 'by' => 'day'}

      expect(response).to render_template("events/summary")
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json['events'].count).to eq(2)
      expect(response_json['events'][0].keys.include?('highfives'))
    end

    it 'returns no results if no events are within given date range' do
      get "/events/summary",
        {
        'from' => (from_date.to_time + 1.year).to_s,
         'to' => (to_date.to_time + 1.year).to_s,
         'by' => 'minute'
      }

      expect(response).to render_template("events/summary")
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json['events'].count).to eq(0)
    end
  end

  context 'given invalid "from" and "to" params' do
    it 'returns a {"status" : "error"} when start date > stop date' do
      get "/events/summary",
        {'from' => to_date,'to' => from_date, 'by' => 'day'}

      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(422)
      expect(response_json['status']).to eq("error")
      expect(response_json.keys).to_not match(/events/)
    end

    it 'returns a {"status" : "error"} when "to" param is missing' do
      get "/events/summary",
        {'from' => from_date, 'by' => 'day'}

      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(422)
      expect(response_json['status']).to eq("error")
      expect(response_json.keys).to_not match(/events/)
    end

    it 'returns a {"status" :"error"} when given an invalid "by" param' do
      get "/events/summary",
        {'from' => from_date,'to' => to_date, 'by' => 'weeks'}

      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(422)
      expect(response_json['status']).to eq("error")
      expect(response_json.keys).to_not match(/events/)
    end
  end
end
describe 'POST /events' do
  it 'saves event date, action, and user' do
    date = Time.now
    params = {event: {:date => date, :user => 'Dennis', :action => 'enters'}}
    post '/events', params.to_json, set_headers

    expect(response.content_type).to eq('application/json')
    expect(response.status).to eq(200)
    expect(response_json['status']).to eq('ok')

    event = Event.last
    expect(event.user).to eq('Dennis')
    expect(event.action).to eq('enters')
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
