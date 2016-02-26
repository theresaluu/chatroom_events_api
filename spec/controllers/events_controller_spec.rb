require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET /events/summary?from=DATE&to=DATE&by=TIMEFRAME' do
    render_views

    context 'start and end date params given' do
      let(:events) do
        dates = ['2015-01-14T10:00Z', '2015-01-25T10:00Z', '2015-02-14T08:00Z',
                 '2015-02-14T10:22Z', '2015-03-14T10:00Z', '2015-04-14T10:00Z',
                 '2015-04-24T10:00Z']
        actions = []

        dates.each do |date|
          actions << create(:event, :date => Time.parse(date).to_time.iso8601)
        end
      end

      before {expect(events.count).to eq 7}
    end
  end
end

