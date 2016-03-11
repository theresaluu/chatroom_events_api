Rails.application.routes.draw do
  post '/events'        => "events#create"
  post '/events/clear'  => "events#clear"
  get '/events'         => "events#range", format: 'json'
  get '/events/summary' => "events#summary", format: 'json'
end
