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
    @events = Event.where(date: date_conversion('from')..date_conversion('to')).sort_by do |event|
      event['date']
    end
  end

  def summary
    @summaries = []
  end

  private
  def event_params
    params.require(:event).permit(:date, :user, :action, :otheruser) if params[:event]
  end

  def date_conversion(direction)
    if direction == 'from'
      Time.parse(params['from'] || params[:from]).utc
    else
      Time.parse(params['to'] || params[:to]).utc
    end
  end

  def event_dates(timeframe)
    event_dates = []
    Event.all.each do |event|
      case timeframe
      when 'minute'
        event_dates << round_down_seconds(event.date).iso8601
      when 'hour'
        event_dates << round_down_minutes(event.date).iso8601
      when 'day'
        event_dates << round_down_minutes(event.date).iso8601
      end
    end
    event_dates.uniq.sort_by do |date|
      date
    end
  end

  def round_down_seconds(date)
    date - date.strftime('%S').to_i.seconds
  end

  def round_down_minutes(date)
    round_down_seconds(date) - date.strftime('%M').to_i.minutes
  end

  def round_down_hours(date)
    round_down_minutes(date) - date.strftime('%H').to_i.hours
  end

  def event_actions(event_dates)
    event_list = []
    event_dates.each do |date|
      counts = Hash.new(0)
      counts[:date] = date
      event_actions = []
      Event.all.each do |event|
        if event.date == date
          event_actions << event.action
        end
      end
      event_actions.each do |event|
        counts[event] += 1
      end
      event_list << counts
    end
  end
end
