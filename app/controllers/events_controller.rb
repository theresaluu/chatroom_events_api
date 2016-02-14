class EventsController < ApplicationController

  def create
    @event = Event.create(event_params)
    if @event
      render json: @event, content_type: 'application/json'
    end
  end
  private
  def event_params
    params.require(:event).permit(:date, :user, :action, :otheruser)
  end
end
