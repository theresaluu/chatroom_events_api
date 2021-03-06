# Chatroom API Events

A Rails 4 API only app to practice TDD with HTTP calls.

<b>Terminal Instructions:</b>
* Installation of app and dependencies  
  * ```git clone git@github.com:theresaluu/chatroom_events_api.git```
  * ```cd chatroom_events_api.git```
  * ```bundle install```

* Initialize the database
  * ```bundle exec rake db:create```
  * ```bundle exec rake db:migrate```

* Start the application
  * ```rails s```

* Run the test suite
  * ```bundle exec rspec```

**Biggest Lesson Learned of this challenge:** Time stores your dates with your time but when you retreive it from the database, the date portion reads the start of Y2K 01/01/2000.  Rails will retreive your date and time correctly when you store your events with a date in DateTime type.  #neverforget #y2k :date: :clock12:

