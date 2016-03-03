json.events @events do |event|
  json.date event.date.iso8601
  json.user event.user
  json.action event.action
  json.message event.message if json.action == 'comment'
  json.otheruser event.othersuer if json.action == 'highfives'
end
