class EventsController < ApplicationController

  def create
    @event = Event.new(event_params)
    if @event.save
      render json: @event, content_type: 'application/json'
    else
      render json: {
        status: 'error',
        errors: @event.errors.full_messages,
        content_type: 'application/json'
      }, status: 422
    end
  end

  def clear
    render json: {
      status: 'ok',
      content_type: 'application/json'
    }, status: 200
  end

  def range
    @events = Event.where(date: date_conversion('from')..date_conversion('to'))
  end

  private
  def event_params
    params.require(:event).permit(:date, :user, :action, :otheruser) if params[:event]
  end

  def date_conversion(direction)
    if direction == 'from'
      Time.parse(params['from'] || params[:from])
    else
      Time.parse(params['to'] || params[:to])
    end
  end
end
