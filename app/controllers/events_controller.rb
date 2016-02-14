class EventsController < ApplicationController

  def create
    @event = Event.new(event_params)
    if @event.save
      render json: @event, content_type: 'application/json'
    end
  end
  private
  def event_params
    params.require(:event).permit(:date, :user, :action, :otheruser) if params[:event]
  end
end
