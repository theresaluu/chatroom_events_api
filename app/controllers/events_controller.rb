class EventsController < ApplicationController

  def create
    @event = Event.new(event_params)
    if @event.save
      render json: { 'status' => 'ok' }
    else
      render json: {
        status: 'error',
        errors: @event.errors.full_messages,
        content_type: 'application/json'
      }, status: 422
    end
  end

  def clear
    render json: { status: 'ok' }
  end

  def range
    if list_params
      @events =
        Event.where(date: date_type('from')..date_type('to')).sort_by do |event|
          event['date']
        end
    else
      render json: {
        content_type: 'application/json',
        status: 'error'
      }, status: 422
    end
  end

  def summary
    if summary_params
      event_collection = Hash.new()
      event_collection['events'] = event_actions(event_dates(params['by']))
      @events = event_collection['events']
    else
      render json: {
        content_type: 'application/json',
        status: 'error'
      }, status: 422
    end
  end

  private
  def event_params
    if params[:event]
      params.require(:event).permit(:date, :user, :action)
    end
  end

  def list_params
    params[:from] && params[:to] && params[:to] > params[:from]
  end

  def summary_params
    list_params &&
      params[:by] &&
      ['minute', 'hour', 'day'].include?(params[:by])
  end

  def date_type(direction)
    if direction == 'from'
      Time.parse(params['from'] || params[:from]).utc
    else
      Time.parse(params['to'] || params[:to]).utc
    end
  end

  def rolled_up_range(timeframe, type)
    case timeframe
    when 'minute'
      round_down_seconds(date_type(type))
    when 'hour'
      round_down_minutes(date_type(type))
    when 'day'
      round_down_hours(date_type(type))
    end
  end

  def collect_rolledup(timeframe, list, action)
    case timeframe
    when 'minute'
      list << round_down_seconds(action.date).iso8601
    when 'hour'
      list << round_down_minutes(action.date).iso8601
    when 'day'
      list << round_down_hours(action.date).iso8601
    end
  end

  def event_dates(timeframe)
    event_dates = []
    from = rolled_up_range(timeframe, 'from')
    to = rolled_up_range(timeframe, 'to')
    Event.where(date: from..to).each do |event|
      collect_rolledup(timeframe, event_dates, event)
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

  def collect_events(date)
    event_actions = []
    timeframe = params['by']
    Event.all.each do |event|
      if (timeframe == 'minute') && round_down_seconds(event.date) == date
        event_actions << event.action
      elsif (timeframe == 'hour') && round_down_minutes(event.date) == date
        event_actions << event.action
      elsif (timeframe == 'day') && round_down_hours(event.date) == date
        event_actions << event.action
      end
    end
    event_actions
  end

  def event_actions(event_dates)
    event_list = []
    event_dates.each do |date|
      counts = Hash.new(0)
      counts[:date] = date
      collect_events(date).each do |event|
        counts[event] += 1
      end
      event_list << counts
    end
    event_list
  end
end
