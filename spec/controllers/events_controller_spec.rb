require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'POST /events' do
    let(:data_received) {{ 'status' => 'ok'}.to_json}
    let(:invalid_post)  {{ 'status' => 'error'}.to_json}

    context 'successful post' do
      let(:post_body) do
        {event: {:date => '2015-05-13T13:00Z', :user => 'Dennis', :action => 'enter'}}
      end

      before { expect(Event.all.count).to eq 0 }

      it 'posts event information successfully and contains a status of "ok"' do
        post :create, post_body, :format => :json
        expect(Event.all.count).to eq 1
        expect(response.status).to eq 200
      end
    end
  end
  describe 'GET /events/summary?from=DATE&to=DATE&by=TIMEFRAME' do
    render_views

    context 'start and end date params given' do
      let(:events) do
        dates = ['2015-01-14T10:00Z', '2015-01-25T10:00Z', '2015-02-14T08:00Z',
                 '2015-05-14T10:22Z', '2015-03-14T10:00Z', '2015-04-14T10:00Z',
                 '2015-04-24T10:00Z']
        actions = []

        dates.each do |date|
          actions << FactoryGirl.create(:event, date: Time.parse(date))
        end
        actions
      end

      before { expect(events.count).to eq 7 }

      it "returns actions occuring between the 'to' and 'from' interval" do
        get :range,
          'from' => '2015-05-13T00:00Z',
          'to' => '2015-06-13T23:59Z',
          format: :json

        expect(response).to render_template("events/range")
        #expect(response.body).to eq({'date' => '2015-05-14T10:22Z'})
      end
    end
  end
end

