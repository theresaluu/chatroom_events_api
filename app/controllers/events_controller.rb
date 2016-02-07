class EventsController < ApplicationController
  def create
    @event = Event.new(event_params)
    render json: @event, content_type: 'application/json'
  end
  private
  def event_params
    params.permit(:date, :user, :type, :otheruser)
  end
end
